import Mirage from 'ember-cli-mirage';

export default Mirage.Factory.extend({

			createdBy(i) { return `createdBy ${i}`;},
			createdDate : new Date(),
			currentVersion(i) { return i;},
			description(i) { return `description ${i}`;},
			lastModifiedBy(i) { return `lastModifiedBy ${i}`;},
			lastModifiedDate : new Date(),
			name(i) { return `name ${i}`;},
			operatingSystemCategory(i) { return `operatingSystemCategory ${i}`;},

});
