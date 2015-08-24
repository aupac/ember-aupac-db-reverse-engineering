import Mirage from 'ember-cli-mirage';

export default Mirage.Factory.extend({

			fromFile(i) { return `fromFile ${i}`;},
			toFile(i) { return `toFile ${i}`;},

});
