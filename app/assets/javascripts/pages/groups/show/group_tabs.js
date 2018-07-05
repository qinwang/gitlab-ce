import $ from 'jquery';
import axios from '~/lib/utils/axios_utils';
import { createGroupTree } from '~/groups';

/**
 * UserTabs
 *
 * Handles persisting and restoring the current tab selection and lazily-loading
 * content on the Users#show page.
 *
 * ### Example Markup
 *
 * <ul class="nav-links">
 *   <li class="activity-tab active">
 *     <a data-action="activity" data-target="#activity" data-toggle="tab" href="/u/username">
 *       Activity
 *     </a>
 *   </li>
 *   <li class="groups-tab">
 *     <a data-action="groups" data-target="#groups" data-toggle="tab" href="/u/username/groups">
 *       Groups
 *     </a>
 *   </li>
 *   <li class="contributed-tab">
 *     ...
 *   </li>
 *   <li class="projects-tab">
 *     ...
 *   </li>
 *   <li class="snippets-tab">
 *     ...
 *   </li>
 * </ul>
 *
 * <div class="tab-content">
 *   <div class="tab-pane" id="activity">
 *     Activity Content
 *   </div>
 *   <div class="tab-pane" id="groups">
 *     Groups Content
 *   </div>
 *   <div class="tab-pane" id="contributed">
 *     Contributed projects content
 *   </div>
 *   <div class="tab-pane" id="projects">
 *    Projects content
 *   </div>
 *   <div class="tab-pane" id="snippets">
 *     Snippets content
 *   </div>
 * </div>
 *
 * <div class="loading-status">
 *   <div class="loading">
 *     Loading Animation
 *   </div>
 * </div>
 */

export default class GroupTabs {
  constructor({ defaultAction, action, parentEl, endpoints }) {
    this.loaded = {};
    this.defaultAction = defaultAction || 'overview';
    this.action = action || this.defaultAction;
    this.$parentEl = $(parentEl) || $(document);
    this.endpoints = {
      default: endpoints.endpointsDefault,
      shared: endpoints.endpointsShared,
    };
    this.windowLocation = window.location;
    this.$parentEl.find('.nav-links a').each((i, navLink) => {
      this.loaded[$(navLink).attr('data-action')] = false;
    });
    this.actions = Object.keys(this.loaded);
    this.bindEvents();

    if (this.action === 'show') {
      this.action = this.defaultAction;
    }

    this.activateTab(this.action);
  }

  bindEvents() {
    this.$parentEl
      .off('shown.bs.tab', '.nav-links a[data-toggle="tab"]')
      .on('shown.bs.tab', '.nav-links a[data-toggle="tab"]', event => this.tabShown(event))
      .on('click', '.gl-pagination a', event => this.changeProjectsPage(event));
  }

  changeProjectsPage(e) {
    e.preventDefault();

    $('.tab-pane.active').empty();
    const endpoint = $(e.target).attr('href');
    this.loadTab(this.getCurrentAction(), endpoint);
  }

  tabShown(event) {
    const $target = $(event.target);
    const action = $target.data('action');
    const source = $target.attr('href');
    let endpoint;

    switch (action) {
      case 'shared':
        endpoint = this.endpoints.shared;
        break;
      default:
        endpoint = this.endpoints.default;
        break;
    }

    this.setTab(action, endpoint);
    return this.setCurrentAction(source);
  }

  activateTab(action) {
    return this.$parentEl.find(`.nav-links .js-${action}-tab a`).tab('show');
  }

  setTab(action, endpoint) {
    if (this.loaded[action]) {
      return;
    }

    const loadableActions = ['overview', 'subgroups', 'shared', 'archived'];
    if (loadableActions.indexOf(action) > -1) {
      this.loadTab(action, endpoint);
    }
  }

  loadTab(action, endpoint) {
    const treesToLoad = [];

    switch (action) {
      case 'overview':
        treesToLoad.push({
          elId: 'js-groups-overview-children-tree',
          endpoint,
        });
        treesToLoad.push({
          elId: 'js-groups-overview-shared-tree',
          endpoint,
        });
        break;
    }

    this.toggleLoading(true);

    treesToLoad.forEach(tree => {
      createGroupTree(tree.elId, endpoint);
    });
    this.loaded[action] = true;

    this.toggleLoading(false);

    // return axios
    //   .get(endpoint)
    //   .then(({ data }) => {
    //     const tabSelector = `div#${action}`;
    //     this.$parentEl.find(tabSelector).html(data.html);
    //     this.loaded[action] = true;

    //     this.toggleLoading(false);
    //   })
    //   .catch(() => {
    //     this.toggleLoading(false);
    //   });
  }

  toggleLoading(status) {
    return this.$parentEl.find('.loading-status .loading').toggleClass('hide', !status);
  }

  setCurrentAction(source) {
    let newState = source;
    newState = newState.replace(/\/+$/, '');
    newState += this.windowLocation.search + this.windowLocation.hash;
    window.history.replaceState(
      {
        url: newState,
      },
      document.title,
      newState,
    );
    return newState;
  }

  getCurrentAction() {
    return this.$parentEl.find('.nav-links a.active').data('action');
  }
}
