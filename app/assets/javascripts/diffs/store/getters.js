import { PARALLEL_DIFF_VIEW_TYPE, INLINE_DIFF_VIEW_TYPE } from '../constants';
import { getDiffLinesByLineCode } from './utils';

export const isParallelView = state => state.diffViewType === PARALLEL_DIFF_VIEW_TYPE;

export const isInlineView = state => state.diffViewType === INLINE_DIFF_VIEW_TYPE;

export const areAllFilesCollapsed = state => state.diffFiles.every(file => file.collapsed);

export const commitId = state => (state.commit && state.commit.id ? state.commit.id : null);

export const discussionsByLineCode = (state, getters) => {
  const diffLinesByLineCode = getDiffLinesByLineCode(state.diffFiles);

  return getters.discussions.reduce((acc, note) => {
    const isDiffDiscussion = note.diff_discussion;
    const hasLineCode = note.line_code;
    const isResolvable = note.resolvable;
    const diffLine = diffLinesByLineCode[note.line_code];

    if (isDiffDiscussion && hasLineCode && isResolvable && diffLine) {
      const { formatter } = note.position;
      const hasSameBaseSha = diffLine.baseSha === formatter.base_sha;
      const hasSameStartSha = diffLine.startSha === formatter.start_sha;
      const hasSameHeadSha = diffLine.headSha === formatter.head_sha;

      if (hasSameBaseSha && hasSameStartSha && hasSameHeadSha) {
        // For context about line notes: there might be multiple notes with the same line code
        const items = acc[note.line_code] || [];
        items.push(note);

        acc[note.line_code] = items;
      }
    }

    return acc;
  }, {});
};

// prevent babel-plugin-rewire from generating an invalid default during karma tests
export default () => {};
