import DS from 'ember-data';

export default DS.Model.extend({
    createdBy : DS.attr('string'),
    createdDate : DS.attr('date'),
    instructions : DS.attr('string'),
    lastModifiedBy : DS.attr('string'),
    lastModifiedDate : DS.attr('date'),
    stepOrder : DS.attr('number'),

    tutorial : DS.belongsTo('tutorial', {async: true }),

    actions : DS.hasMany('action', { async: true, inverse: 'step' })
});
