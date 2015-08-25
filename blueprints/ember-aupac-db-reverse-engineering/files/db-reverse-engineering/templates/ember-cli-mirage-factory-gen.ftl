<#include "./macros.ftl"/>
<#assign simplePropertyCount = 0>
<#assign simplePropertyList = createEmberSimplePropertyList(pojo clazz c2h)>
<#list simplePropertyList?split(',')?sort as item><#if item != ''>
    <#assign simplePropertyCount = simplePropertyCount + 1>
  </#if>
</#list>
import Mirage /*,{faker}*/ from 'ember-cli-mirage';

export default Mirage.Factory.extend({
<#assign currentFieldCount = 0>
<#list simplePropertyList?split(',')?sort as item><#if item != ''>
    <#assign propertyName = item?substring(0, item?index_of(':'))>
    <#assign propertyType = item?substring(item?index_of(':') + 1)>
    <#assign currentFieldCount = currentFieldCount + 1>

    <#assign propertyTypeLower = propertyType?lower_case>

    <#if propertyTypeLower == 'number'>
  ${propertyName}(i) {
    return i;
  }<#if currentFieldCount != simplePropertyCount>,</#if>
      <#elseif propertyTypeLower == 'string'>
  ${propertyName}(i) {
    return `${propertyName} ${"$"}{i}`;
  }<#if currentFieldCount != simplePropertyCount>,</#if>
        <#elseif propertyTypeLower == 'boolean'>
  ${propertyName}: false<#if currentFieldCount != simplePropertyCount>,</#if>
        <#elseif propertyTypeLower == 'date'>
  ${propertyName}: 'faker.date.recent'<#if currentFieldCount != simplePropertyCount>,</#if>
        <#else>
  ${propertyName}: 'UNKNOWN'<#if currentFieldCount != simplePropertyCount>,</#if>
        </#if>
    </#if>
</#list>

});
