<#function getNakedProperty pojo property>
   <#local pos = pojo.getJavaTypeName(property, jdk5)?last_index_of("<")>
   <#return pojo.getJavaTypeName(property, jdk5)?substring(pos + 1, pojo.getJavaTypeName(property, jdk5)?length - 1)>
</#function>

<#function getBooleanPropertyName booleanName>
   <#if booleanName?starts_with("is")>
      <#local booleanName = booleanName?replace("is","","f")?uncap_first>
   </#if>
   <#return booleanName>
</#function>

<#function getPropertyNameFromNakedProperty property, nakedProperty>
    <#local setPropertyName = property.name?cap_first>
    <#if setPropertyName?ends_with("Id")>
       <#local pos = setPropertyName?last_index_of("For")><#assign setPropertyName = setPropertyName?substring(0, pos)>
    <#else>
       <#local setPropertyName = nakedProperty>
    </#if>
    <#return setPropertyName>
</#function>

<#function isNonAuditString pojo property>
   <#return pojo.getJavaTypeName(property, jdk5)?matches("String") && !property.name?matches("createUserId|modifiedUserId")>
</#function>

<#function isAuditField property>
   <#return property.name?matches("createUserId|modifiedUserId|createDate|modifiedDate|version")>
</#function>

<#function isPKorAuditField clazz property>
   <#return property.equals(clazz.identifierProperty) || property.name?matches("createUserId|modifiedUserId|createDate|modifiedDate|version")>
</#function>

<#function getPojoPropertyDefinitionLine pojo property jdk5 javaType propertyName>
   <#local line = pojo.getFieldModifiers(property) + ' ' + javaType + ' ' + propertyName>
   <#if pojo.hasFieldInitializor(property, jdk5)>
      <#local line = line + ' = ' + getJavaInitializer(pojo, property, jdk5)>
   </#if>
   <#return line + ';'>
</#function>

<#function getFieldLength pojo property>
   <#local colString = pojo.generateAnnColumnAnnotation(property)>
   <#local pos = colString?index_of("length=")>
   <#local length = 0>
   <#if pos != -1>
      <#local pos2 = colString?index_of(")", pos)>
      <#local length = colString?substring(pos + 7, pos2)>
   </#if>
   <#return length?number>
</#function>

<#function getCollectionMappedBy pojo, property, cfg>
   <#local colString = pojo.generateCollectionAnnotation(property, cfg)>
   <#local mappedBy = "">
   <#local pos = colString?index_of("mappedBy=")>
   <#if pos != -1>
      <#local pos2 = colString?index_of("\"", pos + 10)>
      <#local mappedBy = colString?substring(pos + 10, pos2)>
   </#if>
   <#return mappedBy>
</#function>

<#function getJavaType pojo property jdk5 clazz>
   <#local javaType = pojo.getJavaTypeName(property, jdk5)>
   <#if javaType.startsWith("Set")>
        <#local javaType = javaType.replaceFirst("Set", "List")>
   </#if>
   <#local javaType = javaType.replaceFirst("byte", "int")>
   <#local javaType = javaType.replaceFirst("short", "int")>
   <#local javaType = javaType.replaceFirst("BigDecimal", "Double")>
   <#local javaType = javaType.replaceFirst("Boolean", "boolean")>
   <#if property.equals(clazz.identifierProperty)>
       <#local javaType = "Long">
   </#if>
   <#return javaType>
</#function>

<#function getJavaInitializer pojo property jdk5>
    <#local init = "">
    <#if pojo.hasFieldInitializor(property, jdk5)>
        <#local init = pojo.getFieldInitialization(property, jdk5)>
        <#local init = init.replaceFirst("HashSet", "ArrayList")>
    </#if>
    <#return init>
</#function>

<#function getLombokToStringExclude pojo c2h>
    <#local count = 0>
    <#local outputList = ' '>
    <#foreach property in pojo.getAllPropertiesIterator()>
        <#if c2h.isManyToOne(property) || c2h.isCollection(property) || c2h.isOneToOne(property)>
           <#local count = count + 1 >
           <#local outputList = outputList + '\"' + property.name + '\", '>
        </#if>
    </#foreach>
   <#return getSortedExludeList(outputList)>
</#function>

<#function getLombokToStringExcludeCount pojo, c2h>
    <#local count = 0>
    <#foreach property in pojo.getAllPropertiesIterator()>
        <#if c2h.isManyToOne(property) || c2h.isCollection(property) || c2h.isOneToOne(property)>
           <#local count = count + 1 >
        </#if>
    </#foreach>
    <#return count>
</#function>

<#function includePropertyInEquals property clazz c2h>
    <#local isIncluded = false>
    <#local res = property.equals(clazz.identifierProperty) || c2h.isManyToOne(property) || c2h.isCollection(property) || c2h.isOneToOne(property)>
    <#if !res>
        <#local isIncluded = true>
    </#if>
    <#return isIncluded>
</#function>

<#function getLombokEqualsExclude pojo clazz c2h>
    <#local count = 0>
    <#local outputList = ' '>
    <#foreach property in pojo.getAllPropertiesIterator()>
        <#if !includePropertyInEquals(property, clazz, c2h)>
           <#local count = count + 1 >
           <#local outputList = outputList + '\"' + property.name + '\", '>
        </#if>
    </#foreach>
   <#return getSortedExludeList(outputList)>
</#function>

<#function getLombokEqualsExcludeCount pojo clazz c2h>
    <#local count = 0>
    <#foreach property in pojo.getAllPropertiesIterator()>
        <#if !includePropertyInEquals(property, clazz, c2h)>
           <#local count = count + 1 >
        </#if>
    </#foreach>
    <#return count>
</#function>

<#function getSortedExludeList inList>
    <#local finalSortedList = ''>
    <#list inList?split(',')?sort as item>
      <#if item != ''>
        <#if finalSortedList = ''>
           <#local finalSortedList = item>
        <#else>
           <#local finalSortedList = finalSortedList + ',' + item>
        </#if>
      </#if>
   </#list>
   <#if finalSortedList?starts_with(' , ')>
      <#local finalSortedList = finalSortedList?substring(3)>
      <#local finalSortedList = finalSortedList + ', '>
   </#if>
   <#return finalSortedList>
</#function>

<#function createDslSimpleObjectSetterList pojo clazz c2h>
<#local resultList = ''>
<#foreach property in pojo.getAllPropertiesIterator()>
    <#if !isPKorAuditField(clazz, property) && !(c2h.isOneToOne(property) || c2h.isManyToOne(property) || c2h.isCollection(property))>
        <#local javaType = pojo.getJavaTypeName(property, jdk5)?lower_case>
        <#local prefix = "obj.set" + property.name?cap_first>
        <#switch javaType>
            <#case "string">
                <#local resultList = addToList(resultList prefix + "(\"" + getStringTestDataForDSL(pojo, property) + "\" + getObjectCount());")>
                <#break>
            <#case "date">
                <#local resultList = addToList(resultList prefix + "(new LocalDate().toDate());")>
                <#break>
            <#case "boolean">
                <#local setterSignature = property.name?replace("is","","f")>
                <#local resultList = addToList(resultList "obj.set" + setterSignature?cap_first + "(false);")>
                <#break>
            <#case "blob">
                <#local resultList = addToList(resultList prefix + "(null);")>
                <#break>
            <#case "short">
                <#local resultList = addToList(resultList prefix + "((short) getObjectCount());")>
                <#break>
            <#case "bigdecimal">
                <#local resultList = addToList(resultList prefix + "(new Double(getObjectCount()));")>
                <#break>
            <#default>
                <#local resultList = addToList(resultList prefix + "(getObjectCount());")>
        </#switch>
    </#if>
</#foreach>
<#return resultList>
</#function>

<#function createEmberSimplePropertyList pojo clazz c2h>
   <#local resultList = ''>
   <#foreach property in pojo.getAllPropertiesIterator()>
      <#if !isPKorAuditField(clazz, property) && !(c2h.isOneToOne(property) || c2h.isManyToOne(property) || c2h.isCollection(property))>
         <#local propertyType = pojo.getJavaTypeName(property, jdk5)>
         <#local propertyName = property.name>
         <#local isjavaNumber = propertyType?lower_case?matches("bigdecimal|biginteger|byte|short|long|integer|int|float|double")>
         <#if isjavaNumber>
             <#local propertyType = 'number'>
         <#else>
            <#local isBoolean = propertyType?lower_case?matches("boolean")>
            <#if isBoolean>
               <#local propertyName = getBooleanPropertyName(propertyName)>
            </#if>
         </#if>
         <#local resultList = addToList(resultList propertyName + ":"  + propertyType)>
      </#if>
   </#foreach>
   <#return resultList>
</#function>

<#function createEmberCollectionList pojo clazz c2h cfg>
   <#local resultList = ''>
   <#foreach property in pojo.getAllPropertiesIterator()>
      <#if !isPKorAuditField(clazz, property) && c2h.isCollection(property)>
         <#local propertyType = pojo.getJavaTypeName(property, jdk5)>
         <#local propertyName = property.name>

         <#local fromPos = propertyType?index_of("<") + 1>
         <#local frontRemoved = propertyType?substring(fromPos, propertyType?length - 1)?uncap_first>
         <#local finalResult = frontRemoved?replace("[A-Z]","-$0", 'r')>
         <#local inverse = getCollectionMappedBy(pojo, property, cfg)>

         <#local resultList = addToList(resultList propertyName + ":"  + finalResult + ":" + inverse)>
      </#if>
   </#foreach>
   <#return resultList>
</#function>

<#function createEmberNonCollectionList pojo clazz c2h>
   <#local resultList = ''>
   <#foreach property in pojo.getAllPropertiesIterator()>
      <#if !isPKorAuditField(clazz, property) && (c2h.isOneToOne(property) || c2h.isManyToOne(property))>
         <#local propertyType = pojo.getJavaTypeName(property, jdk5)?uncap_first>
         <#local propertyName = property.name>
         <#local finalResult = propertyType?replace("[A-Z]","-$0", 'r')>
         <#local resultList = addToList(resultList propertyName + ":"  + finalResult)>
      </#if>
   </#foreach>
   <#return resultList>
</#function>

<#function createDslChildEntityList pojo clazz c2h>
   <#local resultList = ''>
   <#foreach property in pojo.getAllPropertiesIterator()>
      <#if !isPKorAuditField(clazz, property) && (c2h.isOneToOne(property) || c2h.isManyToOne(property))>
         <#local resultList = addToList(resultList pojo.getJavaTypeName(property, jdk5) + ":"  + property.name)>
      </#if>
   </#foreach>
   <#return resultList>
</#function>

<#function getNonAuditStringCount pojo>
   <#local count = 0>
   <#foreach property in pojo.getAllPropertiesIterator()>
      <#if isNonAuditString(pojo, property)>
         <#local count = count + 1>
      </#if>
   </#foreach>
   <#return count>
</#function>

<#function getCollectionCount pojo c2h>
   <#local count = 0>
   <#foreach property in pojo.getAllPropertiesIterator()>
      <#if c2h.isCollection(property)>
         <#local count = count + 1>
      </#if>
   </#foreach>
   <#return count>
</#function>

<#function getManyToOneCount pojo c2h>
    <#local count = 0>
    <#foreach property in pojo.getAllPropertiesIterator()>
        <#if c2h.isManyToOne(property)>
           <#local count = count + 1 >
        </#if>
    </#foreach>
    <#return count>
</#function>

<#function getStringTestDataForDSL pojo property>
   <#local maxFieldLength = getFieldLength(pojo, property) / 2 - 3>
   <#if maxFieldLength lt 1>
      <#local stringField = "">
   <#else>
      <#local stringLength = property.name?length>
      <#if stringLength gt maxFieldLength>
         <#local stringField = property.name?substring(0, maxFieldLength) + "#">
      <#else>
         <#local stringField = property.name + "#">
      </#if>
   </#if>
   <#return stringField>
</#function>

<#function getDslNonRepeatingM21TypeList pojo clazz upperCaseName>
   <#local propertyList = ''>
   <#foreach property in pojo.getAllPropertiesIterator()>
      <#local javaType = pojo.getJavaTypeName(property, jdk5)>
      <#if !isPKorAuditField(clazz, property)  && c2h.isManyToOne(property) && javaType != upperCaseName>
         <#if !propertyList?contains(',' + pojo.getJavaTypeName(property, jdk5))>
            <#local propertyList = propertyList + ',' + pojo.getJavaTypeName(property, jdk5)>
         </#if>
      </#if>
   </#foreach>
   <#return propertyList + ','>
</#function>

<#function getDslNonRepeatingM21TypeCount pojo clazz upperCaseName>
   <#local propertyList = ''>
   <#local count = 0>
   <#foreach property in pojo.getAllPropertiesIterator()>
      <#local javaType = pojo.getJavaTypeName(property, jdk5)>
      <#if !isPKorAuditField(clazz, property) && c2h.isManyToOne(property) && javaType != upperCaseName>
         <#if !propertyList?contains(',' + pojo.getJavaTypeName(property, jdk5))>
            <#local propertyList = propertyList + ',' + pojo.getJavaTypeName(property, jdk5)>
            <#local count = count + 1>
         </#if>
      </#if>
   </#foreach>
   <#return count>
</#function>

<#function getSortedTypeList list pojo>
   <#local sortedList = ''>
   <#local finalSortedList = ''>
   <#foreach property in pojo.getAllPropertiesIterator()>
      <#local javaType = pojo.getJavaTypeName(property, jdk5)>
      <#if list?contains(',' + javaType + ',') && !sortedList?contains(',' + javaType)>
           <#local sortedList = sortedList + ',' + javaType>
      </#if>
   </#foreach>
   <#list sortedList?split(',')?sort as item>
      <#if item != ''>
        <#if finalSortedList = ''>
           <#local finalSortedList = item>
        <#else>
           <#local finalSortedList = finalSortedList + ',' + item>
        </#if>
      </#if>
   </#list>
   <#return finalSortedList>
</#function>

<#function getSortedPropertyList list pojo>
   <#local sortedList = ''>
   <#local finalSortedList = ''>
   <#foreach property in pojo.getAllPropertiesIterator()>
      <#local javaType = pojo.getJavaTypeName(property, jdk5)>
      <#if list?contains(',' + javaType + ',')>
           <#local sortedList = sortedList + ',' + javaType + ":" + property.name>
      </#if>
   </#foreach>
   <#list sortedList?split(',')?sort as item>
      <#if item != ''>
        <#if finalSortedList = ''>
           <#local finalSortedList = item>
        <#else>
           <#local finalSortedList = finalSortedList + ',' + item>
        </#if>
      </#if>
   </#list>
   <#return finalSortedList>
</#function>

<#function getNonAuditStringList pojo>
<#local finalSortedList = ''>
<#foreach property in pojo.getAllPropertiesIterator()>
   <#if isNonAuditString(pojo, property)>
      <#local finalSortedList = addToList(finalSortedList, property.name)>
   </#if>
</#foreach>
<#return finalSortedList>
</#function>

<#function getManyToOneList pojo c2h>
<#local finalSortedList = ''>
<#foreach property in pojo.getAllPropertiesIterator()>
   <#if c2h.isManyToOne(property)>
      <#local finalSortedList = addToList(finalSortedList, property.name)>
   </#if>
</#foreach>
<#return finalSortedList>
</#function>

<#function getNakedSortedPropertyList inPojo inC2h inUpperCaseName>
   <#local sortedList = ','>
   <#local finalSortedList = ''>
   <#foreach property in inPojo.getAllPropertiesIterator()>
      <#if inC2h.isCollection(property)>
          <#local nakedProperty = getNakedProperty(inPojo, property)>
          <#if inUpperCaseName != nakedProperty && !sortedList?contains("," + nakedProperty + ",")>
               <#local sortedList = sortedList + nakedProperty + ','>
          </#if>
      </#if>
   </#foreach>
   <#list sortedList?split(',')?sort as item>
      <#if item != ''>
        <#if finalSortedList = ''>
           <#local finalSortedList = item>
        <#else>
           <#local finalSortedList = finalSortedList + ',' + item>
        </#if>
      </#if>
   </#list>
   <#return finalSortedList>
</#function>

<#function getNakedSortedPropertyListSize list>
   <#return list?split(',')?size>
</#function>

<#function getPlural word>
    <#switch getLetterXCharFromEnd(word, 0)?lower_case>
       <#case "s">
       <#case "x">
       <#case "z">
           <#return word + "es">
          <#break>
       <#case "y">
           <#if isVowel(getLetterXCharFromEnd(word, 1))>
              <#return word + "s">
           <#else>
              <#return word?substring(0, word?length - 1) + "ies">
           </#if>
           <#break>
       <#case "f">
           <#return word?substring(0, word?length - 1) + "ves">
           <#break>
       <#case "o">
           <#if isVowel(getLetterXCharFromEnd(word, 1))>
              <#return word + "s">
           <#else>
              <#return word?substring(0, word?length - 1) + "es">
           </#if>
           <#break>
       <#default>
           <#switch word?substring(word?length - 2, word?length)?lower_case>
               <#case "ch">
               <#case "sh">
                   <#return word + "es">
                   <#break>
               <#case "fe">
                   <#return word?substring(0, word?length - 2) + "ves">
                   <#break>
               <#default>
                   <#return word + "s">
           </#switch>
    </#switch>
</#function>

<#function isVowel letter>
    <#switch letter?lower_case>
       <#case "a">
       <#case "e">
       <#case "i">
       <#case "o">
       <#case "u">
          <#return true>
          <#break>
       <#default>
          <#return false>
    </#switch>
</#function>

<#function getLetterXCharFromEnd word posFromEnd>
   <#return word?substring(word?length - posFromEnd - 1, word?length - posFromEnd)>
</#function>

<#function addToListWithSeperator list item seperator>
   <#if list?contains(seperator + item + seperator )>
       <#return list>
   <#else>
       <#return list + seperator + item>
   </#if>
</#function>

<#function addToList list item>
   <#return addToListWithSeperator(list item ',')>
</#function>

<#function addCollectionImportsToList list inPojo inC2h inPackageName suffix>
<#local propertyList = ",">
<#local outList = list>
<#local import = ",">
<#foreach property in inPojo.getAllPropertiesIterator()><#if inC2h.isCollection(property)><#local nakedProperty = getNakedProperty(inPojo, property)><#if !propertyList?contains("," + nakedProperty + ",")><#local propertyList = propertyList + nakedProperty + ",">
  <#local outList = addToList(outList, inPackageName + '.' + nakedProperty + suffix)>
</#if></#if></#foreach>
<#return outList>
</#function>

<#macro printImports list>
<#list list?split(',')?sort as item><#if item != ''>
import ${item};
</#if></#list>
</#macro>
z
<#macro importCollectionNakedProperties inPojo inC2h inPackageName suffix>
<#local propertyList = ",">
  <#foreach property in inPojo.getAllPropertiesIterator()><#if inC2h.isCollection(property)><#local nakedProperty = getNakedProperty(inPojo, property)><#if !propertyList?contains("," + nakedProperty + ",")><#local propertyList = propertyList + nakedProperty + ",">
import ${inPackageName}.${nakedProperty}${suffix};
</#if></#if></#foreach>
</#macro>

<#macro importCollectionNakedProperties2 inPojo inC2h inPackageName inUpperCaseName suffix>
<#local sortedTypeList = getNakedSortedPropertyList(inPojo, inC2h, inUpperCaseName)>
<#list sortedTypeList?split(',') as javaType><#if javaType != ''>
import ${inPackageName}.${javaType}${suffix};
</#if></#list>
</#macro>

<#macro addVariableDefForCollectionNakedProperties2 inPojo inC2h inUpperCaseName prefix suffix shouldAutowire>
<#local sortedTypeList = getNakedSortedPropertyList(inPojo, inC2h, inUpperCaseName)>
<#list sortedTypeList?split(',') as javaType><#if javaType != ''>
<#if shouldAutowire = "true">

    @Autowired
</#if>
    ${prefix} ${javaType}${suffix} ${javaType?uncap_first}${suffix};
</#if></#list>
</#macro>

<#macro importIfStringCountGt0 inCount import>
<#if inCount gt 0>
import ${import};
</#if>
</#macro>

<#macro importIfPackageNameDifferent inClassPackage inPackage inClass>
<#if inClassPackage != inPackage>
import ${inPackage}.${inClass};
</#if>
</#macro>

<#macro splitLine line maxLength firstLinePrefixLength otherLinesPrefix>
<#local totalLineLength = firstLinePrefixLength + line?length>
<#local tempLine = ''>
<#local tempLine1 = ''>
<#if totalLineLength < maxLength>
${line}<#else><#local tempLine = line?substring(0, maxLength - firstLinePrefixLength)>
<#local commaIndex = tempLine?last_index_of(',')>
<#if commaIndex gt -1>
   <#local tempLine = tempLine?substring(0, commaIndex + 1)>
</#if>${tempLine}
<#local tempLine = line?substring(tempLine?length)>
      <#local maxLoop=10>
      <#list 1..maxLoop as x>
         <#if tempLine?length < maxLength - otherLinesPrefix?length + 1>
${otherLinesPrefix + tempLine}<#break>
         <#else>
            <#local tempLine1 = tempLine?substring(0, maxLength - otherLinesPrefix?length)>
            <#local commaIndex = tempLine1?last_index_of(',')>
            <#if commaIndex gt -1>
                <#local tempLine1 = tempLine1?substring(0, commaIndex + 1)>
            </#if>
${otherLinesPrefix + tempLine1}
            <#local tempLine = tempLine?substring(tempLine1?length)>
         </#if>
      </#list>
   </#if>
</#macro>
