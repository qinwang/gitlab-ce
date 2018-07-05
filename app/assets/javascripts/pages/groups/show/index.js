/* eslint-disable no-new */

import NewGroupChild from '~/groups/new_group_child';
import notificationsDropdown from '~/notifications_dropdown';
import NotificationsForm from '~/notifications_form';
import ProjectsList from '~/projects_list';
import ShortcutsNavigation from '~/shortcuts_navigation';
import initGroupsList from '~/groups';
import GroupTabs from './group_tabs';

document.addEventListener('DOMContentLoaded', () => {
  const newGroupChildWrapper = document.querySelector('.js-new-project-subgroup');
  const { page } = document.body.dataset;
  const tabsParent = '.groups-header';
  const { endpointsDefault, endpointsShared } = document.querySelector(tabsParent).dataset;
  const action = page.split(':')[1];
  new ShortcutsNavigation();
  new NotificationsForm();
  notificationsDropdown();
  new ProjectsList();

  if (newGroupChildWrapper) {
    new NewGroupChild(newGroupChildWrapper);
  }

  new GroupTabs({ parentEl: tabsParent, action, endpoints: { endpointsDefault, endpointsShared } });
  // initGroupsList();
});
