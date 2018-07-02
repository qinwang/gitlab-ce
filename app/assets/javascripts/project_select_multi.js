import $ from 'jquery';
import _ from 'underscore';
import Api from './api';
import { renderAvatar } from './helpers/avatar_helper';

function renderProjectItem(project) {
  const projectTitle = project.name_with_namespace || project.name;

  return (
`<div class="projects-list-item-container clearfix">
  <div class="project-item-avatar-container">
    ${renderAvatar(project)}
  </div>
  <div class="project-item-metadata-container">
    <div title="${_.escape(projectTitle)}" class="project-title">${_.escape(projectTitle)}</div>
    <div title="${_.escape(project.description)}" class="project-namespace">${_.escape(project.description)}</div>
  </div>
</div>`
  );
}

function renderProjectSelection(project) {
  const projectTitle = project.name_with_namespace || project.name;

  return (
`<div class="project-inline-container">
  <div class="project-item-avatar-container">
    ${renderAvatar(project, { sizeClass: 's16' })}
  </div>
  <div title="${_.escape(projectTitle)}" class="project-title">${_.escape(projectTitle)}</div> 
</div>`
  );
}

function createQuerier(queryOptions) {
  return ({ term, callback }) => Api.projects(term, queryOptions)
    .then(results => ({
      results,
    }))
    .then(callback);
}

function removeHiddenInputs(parent) {
  $(parent).children('.js-hidden-input').remove();
}

function addHiddenInputs(parent, val, inputItemName) {
  const inputs = val.map(x =>
    $(`<input type="hidden" class="js-hidden-input" name="${_.escape(inputItemName)}[]" value="${_.escape(x)}" />`),
  );

  inputs.forEach(x => $(parent).append(x));
}

function resetHiddenInputs(parent, val, inputItemName) {
  removeHiddenInputs(parent);
  addHiddenInputs(parent, val, inputItemName);
}

function setupMultiProjectSelect(select) {
  const $select = $(select);
  const inputItemName = $select.data('inputItemName');
  const $iconParent = $select.parents('.input-icon-wrapper').first();

  const queryOptions = {
    order_by: $select.data('orderBy') || 'id',
  };

  $select.select2({
    query: createQuerier(queryOptions),
    multiple: true,
    closeOnSelect: false,
    text: null,
    dropdownCssClass: 'project-multi-select-dropdown dropdown-menu-selectable',
    containerCssClass: 'project-multi-select-dropdown',
    placeholder: 'All Products',
    formatResult: renderProjectItem,
    formatSelection: renderProjectSelection,
    id: x => x.id,
  });

  $select.val([]);

  $select.on('change', e => {
    resetHiddenInputs($select.parent(), e.val, inputItemName);
  });

  $select.on('select2-opening', () => {
    $iconParent.addClass('hide-icon');
  });

  $select.on('select2-close', () => {
    $iconParent.removeClass('hide-icon');
  });

  return select;
}

export default function multiProjectSelect() {
  $('.ajax-project-select').each((i, select) => setupMultiProjectSelect(select));
}
