<#include "./macros.ftl"/>
import Mirage from 'ember-cli-mirage';

export default Mirage.Factory.extend({

<#assign totalFieldCount = 0>
<#assign currentFieldCount = 0>
<#foreach property in pojo.getAllPropertiesIterator()>
    <#if !isPKorAuditField(clazz, property)>
       <#assign totalFieldCount = totalFieldCount + 1>
    </#if>
</#foreach>
<#assign simplePropertyList = createEmberSimplePropertyList(pojo clazz c2h)>
<#list simplePropertyList?split(',')?sort as item><#if item != ''>
       <#assign propertyName = item?substring(0, item?index_of(':'))>
       <#assign propertyType = item?substring(item?index_of(':') + 1)>
       <#assign currentFieldCount = currentFieldCount + 1>

		<#assign propertyTypeLower = propertyType?lower_case>
		<#if propertyTypeLower == 'number'>
			${propertyName}(i) { return i;},
		<#elseif propertyTypeLower == 'string'>
			${propertyName}(i) { return `${propertyName} ${"$"}{i}`;},
		<#elseif propertyTypeLower == 'boolean'>
			${propertyName} : false,
		<#elseif propertyTypeLower == 'date'>
			${propertyName} : new Date(),
		<#else>
			${propertyName} : 'UNKNOWN',
		</#if>
    </#if>
</#list>

});
