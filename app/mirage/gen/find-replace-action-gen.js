import Mirage from 'ember-cli-mirage';

export default Mirage.Factory.extend({

			file(i) { return `file ${i}`;},
			regex(i) { return `regex ${i}`;},
			replaceText(i) { return `replaceText ${i}`;},

});
