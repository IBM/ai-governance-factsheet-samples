<#-- This file collects macros and other helpers that can be use in factsheet reports -->

<#-- conditionalColor marks a stretch of text in a color (if a condition is true)  -->
<#macro header>
<style>
@page {
  @top-center {
    font-family: sans-serif;
    /*font-weight: bold;*/
    font-size: 12pt;
    content: <#nested>
  }
}
</style>
</#macro>

<#macro footer>
<style>
@page {
  @bottom-center {
    font-family: sans-serif;
    /*font-weight: bold;*/
    font-size: 12pt;
    content: <#nested>
  }
}
</style>
</#macro>

<#-- conditionalColor marks a stretch of text in a color (if a condition is true)  -->
<#function conditionalColor str condition=true color="red">
    <#if condition>
    <#return "<span style=\"color:${color}\" >" + str + "</span>" >
    <#else>
        <#return str >
    </#if>
</#function>

<#function color str color="red">
    <#return conditionalColor(str, true, color)>
</#function>

<#-- if a JSON sub-elment can either be an atomic string or an array this macro allows to return the result in one expression -->
<#macro stringOrList expr><#if expr?is_enumerable >${expr?join(" - ","")}<#else>${expr}</#if></#macro>

<#-- if a JSON sub-elment can either be an atomic string or an sub-json (i.e. hash) this macro allows to return the result in one expression -->
<#-- TODO: when it's a hash we should not just return and empty string but some more meaningful string rendering -->
<#macro stringOrHash expr><#if expr?is_hash > <#else>${expr}</#if></#macro>

<#-- uniqueList removes all duplicates from the originalList and assigns the result to outList -->
<#function uniqueList originalList >
    <#assign newList = [] />
    <#list originalList as ol>
        <#if ! newList?seq_contains(ol)>
            <#assign newList = newList + [ol] />
        </#if>
    </#list>
    <#return newList >
</#function>

<#-- environmentClassification assumes a model JSON object as input as returned from the Model use case API call.
     It returns Development, Test, Pre-production or Production -->
<#function environmentClassification model>
    <#switch model.container_type>
    <#case "project">
        <#return "Develop" />
        <#break>
    <#case "space">
        <#switch model.deployment_space_type>
            <#case "development">
                <#return "Test" />
            <#break>
            <#case "pre-production">
                <#return "Pre-Production" />
            <#break>
            <#case "production">
                <#return "Production" />
            <#break>
            <#default>
                <#return "Unknown deployment space type!!" />
        </#switch>
        <#break>
    <#case "catalog">
        <#return "Catalog" />
        <#break>
    <#default>
        <#return "Unknown container type!!" />
    </#switch>
</#function>

<#function getEnvClassForDeploymentSpaceType deployment_space_type>
    <#switch deployment_space_type>
        <#case "development">
            <#return  {"envClass" : "Test", "envClassId" : 1} />
        <#break>
        <#case "pre-production">
            <#return  {"envClass" : "Pre-Production", "envClassId" : 2} />
        <#break>
        <#case "production">
            <#return {"envClass" : "Production", "envClassId" : 3} />
        <#break>
        <#default>
            <#return {"envClass" : "Unknown environment type", "envClassId" : 5} />
    </#switch>
</#function>
<#-- environmentClassification assumes a model JSON object as input as returned from the Model use case API call.
     It creates an enriched copy of th input model object which has the environment class string and an number (for sorting) -->
<#function environmentClassificationObject model>
    <#switch model.container_type>
    <#case "project">
        <#return model + {"envClass" : "Development", "envClassId" : 0} />
        <#break>
    <#case "space">
        <#return model + getEnvClassForDeploymentSpaceType(model.deployment_space_type) />
        <#break>
    <#case "catalog">
        <#if model.type?? && model.type == "external_model">
            <#return model + getEnvClassForDeploymentSpaceType(model.deployment_space_type) />
        <#else> <#-- wml model -->
        <#return model + {"envClass" : "Catalog", "envClassId" : 4} />
        </#if>
        <#break>
    <#default>
        <#return model + {"envClass" : "Unknown environment type", "envClassId" : 5} />
    </#switch>
</#function>

<#function preprocessPhysicalModels models>
    <#assign newList = [] />
    <#list models as model>
        <#assign newList = newList + [environmentClassificationObject(model)]  />
    </#list>
    <#return newList >
</#function>

<#-- Takes the original Array and arranges in order of arrangeArray and returns a new Array -->
<#function arrangeList originalArray arrangeArray>
    <#assign newList = [] />
    <#list arrangeArray as item>
        <#if originalArray?seq_contains(item) >
            <#assign newList += [(item)]  />
        </#if>
    </#list>
    <#return newList >
</#function>

<#-- Unused - delete later onc we decide to not pursue this approach to metadata
<#ftl 
    attributes={
        "name": "Model Report",
        "description": "A sample template to illustrate reporting against model facts",
        "type": "Model"
    } 
>
-->
<#-- Above is an exploratory/experimental and optional header section to see if/how we could use embedded metadata in a template.
     The ftl attributes section above must be the very first in the file. 
     It allows to put some metadata about the template right into the template itself
     This can be read programmatically. The "type" could give an indication that this template needs to be used with
     data conforming to the model REST API results (as opposed to Model use case) that would allow for conistency checks.
     The "name" and "description" could be used to in the UI to allow users to pick a template by name and description. 
     Embeded metadata has its advantages (can't be separated/lost from the actual template). 
     But as a disadvantage it makes the template "ugly" and complex and it's easy to have typos.
     But we may still want to explore other ways to store this metadata. -->
