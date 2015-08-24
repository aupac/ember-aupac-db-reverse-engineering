import DS from 'ember-data';

export default DS.Model.extend({
    fromFile : DS.attr('string'),
    toFile : DS.attr('string'),

    action : DS.belongsTo('action', {async: true })

});
