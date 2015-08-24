import DS from 'ember-data';

export default DS.Model.extend({
    actionOrder : DS.attr('number'),
    createdBy : DS.attr('string'),
    createdDate : DS.attr('date'),
    instructions : DS.attr('string'),
    lastModifiedBy : DS.attr('string'),
    lastModifiedDate : DS.attr('date'),
    osVersion : DS.attr('string'),

    copyAction : DS.belongsTo('copy-action', {async: true }),
    deleteAction : DS.belongsTo('delete-action', {async: true }),
    findReplaceAction : DS.belongsTo('find-replace-action', {async: true }),
    moveAction : DS.belongsTo('move-action', {async: true }),
    step : DS.belongsTo('step', {async: true })

});
