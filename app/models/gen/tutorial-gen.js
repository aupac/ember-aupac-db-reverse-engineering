import DS from 'ember-data';

export default DS.Model.extend({
    createdBy : DS.attr('string'),
    createdDate : DS.attr('date'),
    currentVersion : DS.attr('number'),
    description : DS.attr('string'),
    lastModifiedBy : DS.attr('string'),
    lastModifiedDate : DS.attr('date'),
    name : DS.attr('string'),
    operatingSystemCategory : DS.attr('string'),


    steps : DS.hasMany('step', { async: true, inverse: 'tutorial' })
});
