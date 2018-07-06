import * as getters from '~/diffs/store/getters';
import state from '~/diffs/store/modules/diff_state';
import { PARALLEL_DIFF_VIEW_TYPE, INLINE_DIFF_VIEW_TYPE } from '~/diffs/constants';
import diffFileMockData from '../mock_data/diff_file';
import diffDiscussionsMockData from '../mock_data/diff_discussions';

describe('DiffsStoreGetters', () => {
  let localState;

  beforeEach(() => {
    localState = state();
  });

  describe('isParallelView', () => {
    it('should return true if view set to parallel view', () => {
      localState.diffViewType = PARALLEL_DIFF_VIEW_TYPE;

      expect(getters.isParallelView(localState)).toEqual(true);
    });

    it('should return false if view not to parallel view', () => {
      localState.diffViewType = INLINE_DIFF_VIEW_TYPE;

      expect(getters.isParallelView(localState)).toEqual(false);
    });
  });

  describe('isInlineView', () => {
    it('should return true if view set to inline view', () => {
      localState.diffViewType = INLINE_DIFF_VIEW_TYPE;

      expect(getters.isInlineView(localState)).toEqual(true);
    });

    it('should return false if view not to inline view', () => {
      localState.diffViewType = PARALLEL_DIFF_VIEW_TYPE;

      expect(getters.isInlineView(localState)).toEqual(false);
    });
  });

  describe('areAllFilesCollapsed', () => {
    it('returns true when all files are collapsed', () => {
      localState.diffFiles = [{ collapsed: true }, { collapsed: true }];
      expect(getters.areAllFilesCollapsed(localState)).toEqual(true);
    });

    it('returns false when at least one file is not collapsed', () => {
      localState.diffFiles = [{ collapsed: false }, { collapsed: true }];
      expect(getters.areAllFilesCollapsed(localState)).toEqual(false);
    });
  });

  describe('commitId', () => {
    it('returns commit id when is set', () => {
      const commitID = '800f7a91';
      localState.commit = {
        id: commitID,
      };

      expect(getters.commitId(localState)).toEqual(commitID);
    });

    it('returns null when no commit is set', () => {
      expect(getters.commitId(localState)).toEqual(null);
    });
  });

  describe('discussionsByLineCode', () => {
    let diffFileMock;
    let diffDiscussionsMock;
    let mockState;

    beforeEach(() => {
      diffFileMock = Object.assign({}, diffFileMockData);
      diffDiscussionsMock = Object.assign({}, diffDiscussionsMockData);
      mockState = { diffFiles: [diffFileMock] };
    });

    it('should return a map of diff lines with their line codes', () => {
      const mockGetters = { discussions: [diffDiscussionsMock] };

      const map = getters.discussionsByLineCode(mockState, mockGetters);
      expect(map['1c497fbb3a46b78edf04cc2a2fa33f67e3ffbe2a_1_2']).toBeDefined();
      expect(Object.keys(map).length).toEqual(1);
    });

    it('should not add an outdated diff discussion to the returned map', () => {
      diffDiscussionsMock.position.formatter.base_sha = 'ff9200';
      const mockGetters = { discussions: [diffDiscussionsMock] };

      const map = getters.discussionsByLineCode(mockState, mockGetters);
      expect(Object.keys(map).length).toEqual(0);
    });
  });
});
