import $ from 'jquery';
import _ from 'underscore';
import Api from './api';
import { renderAvatar } from './helpers/avatar_helper';

const PER_PAGE = 20;

function renderInputIcon() {
  return '<i class="fa fa-angle-down input-icon-right" aria-hidden="true" data-hidden="true"></i>';
}

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
  return ({ term, callback, page }) => Api.projects(term, { ...queryOptions, page })
    .then(results => ({
      results,
      more: results.length === PER_PAGE,
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

function mapIdsToProjects(val) {
  if (!val) {
    return Promise.resolve([]);
  }

  const ids = Array.isArray(val) ? val : [val];
  const reqs = ids.map(id => Api.project(id).catch(() => null));

  return Promise.all(reqs)
    .then(projs => projs.filter(x => x));
}

function setupMultiProjectSelect(select) {
  const $select = $(select);
  const inputName = $select.data('inputName');

  const queryOptions = {
    order_by: $select.data('orderBy') || 'id',
    per_page: PER_PAGE,
  };

  $select.select2({
    query: createQuerier(queryOptions),
    minimumInputLength: 0,
    multiple: true,
    closeOnSelect: false,
    dropdownCssClass: 'project-multi-select-dropdown',
    containerCssClass: 'project-multi-select-dropdown',
    placeholder: 'All Products',
    formatResult: renderProjectItem,
    formatSelection: renderProjectSelection,
    initSelection: (element, callback) => mapIdsToProjects(element.val()).then(callback),
    id: x => x.id,
  });

  const $select2Container = $select.select2('container');

  $select.val([]);

  // setup: on change, add hidden input fields for each value
  $select.on('change', e => {
    const val = e.val || $select.select2('val');

    resetHiddenInputs($select.parent(), val, inputName);
  });

  // setup: add the input icon which is toggled on/off when loading
  //   - this prevents collision with select2's spinner
  $select2Container.append(renderInputIcon());

  $select.on('select2-opening', () => {
    $select2Container.addClass('hide-input-icon');
  });

  $select.on('select2-close', () => {
    $select2Container.removeClass('hide-input-icon');
  });

  return select;
}

export default function multiProjectSelect() {
  $('.ajax-project-select').each((i, select) => setupMultiProjectSelect(select));
}
