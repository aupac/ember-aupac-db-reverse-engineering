<#include "./macros.ftl"/>
import Ember from 'ember';
import DS from 'ember-data';

export default Ember.Mixin.create({
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
       <#if propertyType == 'number'>
  ${propertyName}: DS.attr('${propertyType?lower_case}', { defaultValue: 0 })<#if currentFieldCount != totalFieldCount>,</#if>
       <#else>
  ${propertyName}: DS.attr('${propertyType?lower_case}')<#if currentFieldCount != totalFieldCount>,</#if>
       </#if>
    </#if>
</#list>
<#assign simpleFieldCount = currentFieldCount>
<#if simpleFieldCount != 0 && currentFieldCount != totalFieldCount>

</#if>
<#assign nonCollectionList = createEmberNonCollectionList(pojo clazz c2h)>
<#list nonCollectionList?split(',')?sort as item><#if item != ''>
       <#assign propertyName = item?substring(0, item?index_of(':'))>
       <#assign propertyType = item?substring(item?index_of(':') + 1)>
       <#assign currentFieldCount = currentFieldCount + 1>
  ${propertyName}: DS.belongsTo('${propertyType?lower_case}', { async: true })<#if currentFieldCount != totalFieldCount>,</#if>
   </#if>
</#list>
<#assign nonCollection = currentFieldCount - simpleFieldCount>
<#if nonCollection != 0 && currentFieldCount != totalFieldCount>

</#if>
<#assign collectionList = createEmberCollectionList(pojo clazz c2h cfg)>
<#list collectionList?split(',')?sort as item><#if item != ''>
       <#assign propertyName = item?substring(0, item?index_of(':'))>
       <#assign finalResult = item?substring(item?index_of(':') + 1, item?last_index_of(':'))>
       <#assign inverse = item?substring(item?last_index_of(':') + 1)>
       <#assign currentFieldCount = currentFieldCount + 1>
  ${propertyName}: DS.hasMany('${finalResult?lower_case}', { async: true, inverse: '${inverse}' })<#if currentFieldCount != totalFieldCount>,</#if>
    </#if>
</#list>
});
