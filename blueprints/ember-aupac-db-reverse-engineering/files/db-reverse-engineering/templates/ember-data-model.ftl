import DS from 'ember-data';
import AutoGen from './gen/${pojo.getDeclarationName()?replace("[A-Z]", "-$0", 'r')?lower_case?substring(1)}-gen';

export default DS.Model.extend(AutoGen, {});
