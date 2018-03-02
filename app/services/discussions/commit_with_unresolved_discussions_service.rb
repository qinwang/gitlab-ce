module Discussions
  class CommitWithUnresolvedDiscussionsService < Discussions::BaseService
    COMMENTERS = {
      double_slash: lambda { |l| "// #{l}" },
      pound:        lambda { |l| "# #{l}" },
      xml:          lambda { |l| "<!-- #{l} -->" }
    }.freeze

    COMMENT_TYPES_BY_LANG = {
      default: :double_slash,

      php: :double_slash,
      javascript: :double_slash,
      c: :double_slash,

      markdown: :xml,
      html: :xml,
      xml: :xml,

      ruby: :pound,
      yaml: :pound
    }.freeze

    def execute(merge_request)
      @merge_request = merge_request

      return unless @merge_request.source_branch_exists?

      commit_sha = repository.multi_action(
        @merge_request.author,
        branch_name: nil, # We just want a commit, not a branch
        message: commit_message,
        start_branch_name: @merge_request.source_branch,
        start_project: @merge_request.source_project,
        actions: update_actions
      )
      return unless commit_sha

      project.commit(commit_sha)
    end

    private

    def update_actions
      insertions_by_path.map do |path, insertions|
        {
          action: :update,
          file_path: path,
          content: content_for_path(path, insertions)
        }
      end
    end

    def insertions_by_path
      discussions.map do |discussion|
        insertion_for_discussion(discussion)
      end.group_by(&:path)
    end

    def discussions
      @discussions ||= @merge_request
        .grouped_diff_discussions.values.flatten
        .select { |d| d.on_text? && d.expanded? && d.position && !d.diff_file.deleted_file? }
    end

    def insertion_for_discussion(discussion)
      sections = []

      position = discussion.position
      if position.removed?
        line = discussion.diff_line.new_pos - 1
        priority = 2

        preceding_diff_lines = discussion.truncated_diff_lines(highlight: false)
        removed_diff_lines = preceding_diff_lines
          .reverse[0, 5]
          .take_while(&:removed?)
          .reverse
          .map { |l| l.text[1..-1] }

        preceding_lines = removed_diff_lines

        indented_removed_diff = indent_text(removed_diff_lines.join("\n").strip_heredoc)
        sections << ["Old #{"line".pluralize(removed_diff_lines.count)}:", indented_removed_diff].join("\n")
      else
        line = position.new_line
        priority = 1
      end

      discussion.notes.each_with_index do |note, i|
        sections << text_for_note(note, i)
      end

      OpenStruct.new(
        path: position.file_path,
        line: line,
        text: sections.join("\n\n"),
        priority: priority,
        preceding_lines: preceding_lines
      )
    end

    def content_for_path(path, insertions)
      blob = repository.blob_at(@merge_request.diff_head_sha, path)
      blob.load_all_data!

      content = blob.data.dup
      content << "\n" unless content.end_with?("\n")
      lines = content.lines

      commenter = commenter_for_blob(blob)

      insert_insertions(lines, insertions, commenter)

      lines.join
    end

    def insert_insertions(lines, insertions, commenter)
      insertions.sort_by!(&:line)

      line_offset = 0
      insertions.group_by(&:line).each do |line, insertions|
        insertions.sort_by!(&:priority)

        insertions.each do |insertion|
          line_index = line + line_offset

          preceding_lines = insertion&.preceding_lines || lines[0..line_index-1]
          insertion_lines = format_insertion(insertion, preceding_lines, commenter)

          lines.insert(line_index, *insertion_lines)
          line_offset += insertion_lines.length
        end
      end

      lines
    end

    def format_insertion(insertion, preceding_lines, commenter)
      text = insertion.text
      text << "\n" unless text.end_with?("\n")
      text << "\n"

      lines = text.lines.map { |l| commenter.call(l.rstrip).rstrip }
      lines = indent_lines(lines, preceding_lines)

      lines.map { |l| "#{l}\n" }
    end

    def commenter_for_blob(blob)
      lexer = Gitlab::Highlight.new(blob.name, blob.data, repository: repository).lexer
      lang = lexer.tag.to_sym
      comment_type = COMMENT_TYPES_BY_LANG[lang] || COMMENT_TYPES_BY_LANG[:default]
      COMMENTERS[comment_type]
    end

    def indent_lines(lines, preceding_lines)
      preceding_line = nil
      begin
        preceding_line = preceding_lines.pop
      end while preceding_line&.blank?

      return lines unless preceding_line

      indentation = preceding_line[/\A[\t ]+/]
      return lines unless indentation && indentation.length > 0

      lines.map { |line| [indentation, line].join }
    end

    def commit_message
      <<~MSG
        FIXME: Add code comments for unresolved discussions

        This patch adds a code comment for every unresolved discussion on the
        latest version of the diff of #{@merge_request.to_reference(full: true)}.

        This commit was automatically generated by GitLab. Be sure to remove it
        from the merge request branch it is merged.
      MSG
    end

    def text_for_note(note, i)
      byline = "FIXME: #{note.author.name} (#{note.author.to_reference}) "
      byline << (i == 0 ? "started a discussion on the preceding line:" : "commented:")
      byline << " (Resolved by #{note.resolved_by.try(:name)})" if note.resolved?

      comment = indent_text(note.note)

      [byline, comment].join("\n")
    end

    def indent_text(text)
      text.lines.map { |l| "  #{l}" }.join
    end
  end
end
