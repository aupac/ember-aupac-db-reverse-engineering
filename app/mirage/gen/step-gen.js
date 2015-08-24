import Mirage from 'ember-cli-mirage';

export default Mirage.Factory.extend({

			createdBy(i) { return `createdBy ${i}`;},
			createdDate : new Date(),
			instructions(i) { return `instructions ${i}`;},
			lastModifiedBy(i) { return `lastModifiedBy ${i}`;},
			lastModifiedDate : new Date(),
			stepOrder(i) { return i;},

});
