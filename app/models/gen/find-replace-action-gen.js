import DS from 'ember-data';

export default DS.Model.extend({
    file : DS.attr('string'),
    regex : DS.attr('string'),
    replaceText : DS.attr('string'),

    action : DS.belongsTo('action', {async: true })

});
