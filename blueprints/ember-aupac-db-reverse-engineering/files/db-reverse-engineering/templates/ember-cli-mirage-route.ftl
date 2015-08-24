<#include "./macros.ftl"/>
<#assign camelName = pojo.getDeclarationName()?uncap_first>
<#assign camelPluralName = getPlural(camelName)>
<#assign dasherizedNamePlural = camelPluralName?cap_first?replace("[A-Z]", "-$0", 'r')?lower_case?substring(1)>

this.get('/${camelPluralName}', '${dasherizedNamePlural}');
this.get('/${camelPluralName}/:id', '${dasherizedNamePlural}');
this.post('/${camelPluralName}', '${dasherizedNamePlural}');
this.put('/${camelPluralName}/:id', '${dasherizedNamePlural}');
this.del('/${camelPluralName}/:id', '${dasherizedNamePlural}');
