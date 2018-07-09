import { PARALLEL_DIFF_VIEW_TYPE, INLINE_DIFF_VIEW_TYPE } from '../constants';
import { getDiffRefsByLineCode } from './utils';

export const isParallelView = state => state.diffViewType === PARALLEL_DIFF_VIEW_TYPE;

export const isInlineView = state => state.diffViewType === INLINE_DIFF_VIEW_TYPE;

export const areAllFilesCollapsed = state => state.diffFiles.every(file => file.collapsed);

export const commitId = state => (state.commit && state.commit.id ? state.commit.id : null);

export const discussionsByLineCode = (state, getters, rootState, rootGetters) => {
  const diffRefsByLineCode = getDiffRefsByLineCode(state.diffFiles);

  return rootGetters.discussions.reduce((acc, note) => {
    const isDiffDiscussion = note.diff_discussion;
    const hasLineCode = note.line_code;
    const isResolvable = note.resolvable;
    const diffRefs = diffRefsByLineCode[note.line_code];

    if (isDiffDiscussion && hasLineCode && isResolvable && diffRefs) {
      const { formatter } = note.position;
      const hasSameBaseSha = diffRefs.baseSha === formatter.base_sha;
      const hasSameStartSha = diffRefs.startSha === formatter.start_sha;
      const hasSameHeadSha = diffRefs.headSha === formatter.head_sha;

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
