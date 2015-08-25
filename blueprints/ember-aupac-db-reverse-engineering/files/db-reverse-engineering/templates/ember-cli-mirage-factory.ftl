// import {faker} from 'ember-cli-mirage';
import AutoGen from '../gen/${pojo.getDeclarationName()?replace("[A-Z]", "-$0", 'r')?lower_case?substring(1)}-gen';

export default AutoGen.extend({});