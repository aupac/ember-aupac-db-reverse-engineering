import Mirage from 'ember-cli-mirage';

export default Mirage.Factory.extend({

			actionOrder(i) { return i;},
			createdBy(i) { return `createdBy ${i}`;},
			createdDate : new Date(),
			instructions(i) { return `instructions ${i}`;},
			lastModifiedBy(i) { return `lastModifiedBy ${i}`;},
			lastModifiedDate : new Date(),
			osVersion(i) { return `osVersion ${i}`;},

});
