<#-- This file collects common reporting macros used in factsheet reports -->
<#import "factsheet_utils.ftl" as utils>
<#------------------------------------------------------------------------------->
<#-- Helpers to deal with type defintions for custom attributes/facts          -->
<#------------------------------------------------------------------------------->

<#--  Set a global variable for the new section in the input JSON with all "custom_fact_definitions"  -->
<#global global_custom_fact_definitions=custom_fact_definitions!{}/>

<#--  get the label for one fact out of a specific type definition  -->
<#function getCustomFactLabel fact_id custom_fact_definition>
     <#if (custom_fact_definition["properties"][fact_id])?? >
          <#return custom_fact_definition["properties"][fact_id]["label"]["default"] />
     <#else>
          <#--  we  sometimes have "old" fact values that are left in CAMS after the type definition has been changed -->
          <#return fact_id />
     </#if>
</#function>

<#--  check if a fact is defined in a specific type definition  -->
<#function isCustomFactDefined fact_id custom_fact_definition>
     <#return (custom_fact_definition["properties"][fact_id])?? >
</#function>

<#------------------------------------------------------------------------------->
<#-- Display custom facts (same for model, Model use case, openpages, ...)        -->
<#-- Input: The JSON for the decorator type                                    -->
<#------------------------------------------------------------------------------->

<#macro display_custom_facts custom_facts custom_fact_definition custom_facts_header="Additional Details">
<#if (custom_facts)?has_content>
## ${custom_facts_header}
<#-- First list all custom facts an atomic type (string, int, date, ..) -->
<#list custom_facts?keys as fact_key>
<#if !custom_facts[fact_key]?is_enumerable >
<#if commons.isCustomFactDefined(fact_key, custom_fact_definition)> 
**${commons.getCustomFactLabel(fact_key, custom_fact_definition)}:** ${custom_facts[fact_key]}
<#else>
<#--  we  sometimes have "old" fact values that are left in CAMS after the type defintion has been changed 
          so we won't find the labels for them any more. 
          We should not show them at all - at least that is what what the UI does) -->
${fact_key}: ${custom_facts[fact_key]}
</#if>
</#if>
</#list>
<#-- Now list all custom facts with value arrays -->
<#list custom_facts?keys as fact_key>
<#if custom_facts[fact_key]?is_enumerable >
<#if commons.isCustomFactDefined(fact_key, custom_fact_definition)> 
**${commons.getCustomFactLabel(fact_key, custom_fact_definition)}:**
<#list custom_facts[fact_key] as array_fact_value>
- ${array_fact_value}
</#list><#-- The empty line below is important to keep lists separated -->

</#if>
</#if>
</#list>
</#if>
</#macro>

<#------------------------------------------------------------------------------->
<#-- Additional details/Custom facts for model entries                         -->
<#-- Input: Model use case JSON                                                   -->
<#------------------------------------------------------------------------------->

<#macro additional_details_model_entry model_entry custom_facts_header="Additional Model use case Details">
<#if (model_entry.model_entry_user)??>
<@commons.display_custom_facts (model_entry.model_entry_user)!{} global_custom_fact_definitions["model_entry_user"]!{} custom_facts_header/>
</#if>
</#macro>

<#------------------------------------------------------------------------------->
<#-- Additional details/Custom facts for models                                -->
<#-- Input: model JSON                                                         -->
<#------------------------------------------------------------------------------->
<#macro additional_details_model model custom_facts_header="Additional Model Details">
<#if (model.additional_details)??>
<@commons.display_custom_facts (model.additional_details)!{} global_custom_fact_definitions["modelfacts_user"]!{} custom_facts_header/>
</#if>
</#macro>

<#------------------------------------------------------------------------------->
<#-- Additional details/Custom facts from OpenPage for models                  -->
<#-- Input: model JSON                                                         -->
<#------------------------------------------------------------------------------->
<#macro additional_details_openpages_model model custom_facts_header="Additional IBM Openpages Model Details">
<#if (model.additional_details_op)??>
<@commons.display_custom_facts (model.additional_details_op)!{} global_custom_fact_definitions["modelfacts_user"]!{} custom_facts_header/>
</#if>
</#macro>

<#------------------------------------------------------------------------------->
<#-- Additional details/Custom facts from OpenPage for model entries           -->
<#-- Input: model JSON                                                         -->
<#------------------------------------------------------------------------------->
<#macro additional_details_openpages_model_entry model_entry custom_facts_header="Additional IBM Openpages Model use case Details">
<#if (model_entry.additional_details_op)??>
<@commons.display_custom_facts (model_entry.additional_details_op)!{} global_custom_fact_definitions["model_entry_user"]!{} custom_facts_header/>
</#if>
</#macro>

<#------------------------------------------------------------------------------->
<#-- Notebook Experimentss                                                     -->
<#-- Input: one                                                                -->
<#-- Report output for training_data, training_metrics, schemas                -->
<#------------------------------------------------------------------------------->
<#macro notebook_experiment_report system_facts >
<#if (system_facts.notebook_experiment)?? >
### Notebook Training Facts
<#if (system_facts.notebook_experiment.params)?? >

### Training Parameters

|Parameter|Value|
|:---|:---|
<#list system_facts.notebook_experiment.params?sort_by("key") as Param>
|${Param.key}|${Param.value?replace("\n", "")!}|
</#list>
</#if>
<#if (system_facts.notebook_experiment.metrics)?? >

### Training Metrics

|Metric|Value|
|:---|:---|
<#list system_facts.notebook_experiment.metrics?sort_by("key") as Metric>
|${Metric.key}|${Metric.value!}|
</#list>
</#if>
<#if (system_facts.notebook_experiment.tags)?? >

### Training Tags


|Tag|Value|
|:---|:---|
<#list system_facts.notebook_experiment.tags?sort_by("key") as Tag>
|${Tag.key}|${Tag.value!}|
</#list>
</#if>
</#if>
</#macro>

<#------------------------------------------------------------------------------->
<#-- Training data references                                                  -->
<#-- Input: model entry system facts or whole model JSON                       -->
<#-- Report output for training_data, training_metrics, schemas                -->
<#------------------------------------------------------------------------------->
<#macro training_data_references_report training_data_references >
<#if (training_data_references)?? >
### Training Data Information

<#list training_data_references as DataRef > 
<#if (DataRef.training_data)?? && (DataRef.training_data?length > 0) >
**Training data:** `${DataRef.training_data}` <#if (DataRef.training_data_href)??  && (DataRef.training_data_href?length > 0)>[Link](${DataRef.training_data_href}) </#if>

<#if (DataRef.source)?? && (DataRef.source?length > 0) >
**Training data:** `${DataRef.source}` <#if (DataRef.source_href)??   && (DataRef.source_href?length > 0)>[Link](${DataRef.source_href}) </#if>
</#if>
<#if (DataRef.source_path)?? && (DataRef.source_path?length > 0)>
**Source path:** ${DataRef.source_path}
</#if>
<#if (DataRef.source_type)?? && (DataRef.source_type?length > 0)>
**Source type:** ${DataRef.source_type}
</#if>
<#if (DataRef.type)?? && (DataRef.type?length > 0)>
**Type:** ${DataRef.type}
</#if>

<#else>
could not locate the asset
</#if>

</#list>
</#if>
</#macro>

<#------------------------------------------------------------------------------->
<#-- Training information                                                      -->
<#-- Input: model entry system facts or whole model JSON                       -->
<#-- Report output for training_data, training_metrics, schemas                -->
<#------------------------------------------------------------------------------->
<#macro training_information_report system_facts show_training_data_references=true>
<#if !(system_facts)??>No system facts available for this model!</#if>
<#if (system_facts.hyper_parameters)?? && (system_facts.hyper_parameters?length > 0) >
**Hyper parameters:** ${system_facts.hyper_parameters}
</#if>
<#if (system_facts.features)?? && (system_facts.features > 0) >
**Features:** ${system_facts.features}
</#if>
<#if (system_facts.hybrid_pipeline)?? && (system_facts.hybrid_pipeline.size > 0) >
**Hybrid pipeline:** ${(system_facts.hybrid_pipeline?map(pipeline -> pipeline.name)?join(", ","_(empty)_"))!}
</#if>

<#if show_training_data_references && (system_facts.training_information.training_data_references)?? >
<@commons.training_data_references_report system_facts.training_information.training_data_references />
</#if>

<@commons.notebook_experiment_report system_facts />

<#if system_facts.training_metrics??>
### Training Metrics

<!-- ml_metrics objects are tricky: some only have "custom_value" some have both "training_value" and "holdout_value" keys -->
<!-- <#assign valueList = [] /> -->
<#if (system_facts.training_metrics[0].ml_metrics[0])?? >
<#assign valueKeys = system_facts.training_metrics[0].ml_metrics[0]?keys?filter(key -> key?ends_with("value")) />
<#assign valueLabels = valueKeys?map(value -> (value[0..value?length-7])?cap_first) />
</#if>

|Name|<#list valueLabels as valueLabel>${valueLabel}|</#list>
|:---|<#list valueLabels as valueLabel>:---|</#list>
<#list system_facts.training_metrics as Metric>
<#list Metric.ml_metrics as MlMetric>
|${MlMetric.name!}|<#list valueKeys as valueKey>${("MlMetric."+valueKey)?eval}|</#list>
</#list>
</#list>
</#if>

<#assign i= 1>
<#if (system_facts.schemas.input)?? && (system_facts.schemas.input?size > 0) >
### Input Schema

<#list system_facts.schemas.input as InputSchema>

**Input ${i}:** ${InputSchema.id!}

<#if (InputSchema.fields)?? && (InputSchema.fields?size > 0) >
|Name|Type|
|:---|:---|
<#list InputSchema.fields as Field>
|${Field.name}|${Field.type}|
</#list>
</#if>
<#assign i = i+1>
</#list>
</#if>

<#assign i= 1>
<#if (system_facts.schemas.output)?? && (system_facts.schemas.output?size > 0) >
### Output Schema

<#list system_facts.schemas.output as OutputSchema>

**Output ${i}:** ${OutputSchema.id!}

<#if (OutputSchema.fields)?? && (OutputSchema.fields?size > 0) >
|Name|Type|Measure|Modeling Role|
|:---|:---|:------|:------------|
<#list OutputSchema.fields as Field>
|${(Field.name)!}|<@utils.stringOrHash (Field.type)/>|${(Field.metadata.measure)!}|${(Field.metadata.modeling_role)!}|
</#list>
</#if>
<#assign i = i+1>
</#list>
</#if>
</#macro>

<#------------------------------------------------------------------------------->
<#-- Model Information Report                                                  -->
<#-- Input: model_information JSON  (works both for model and model entry JSON)-->
<#-- Report basic metadata about the model                                     -->
<#------------------------------------------------------------------------------->
<#macro model_information_report model_information ommitNameAndID=false >
<#if !ommitNameAndID >
**Name:**            ${model_information.model_name!"_(not specified)_"}
**Model ID:**        ${model_information.model_id!"_(not specified)_"}
</#if>
<#if (model_information.model_description)?? && model_information.model_description?has_content >
**Description:**     ${model_information.model_description!"_(not specified)_"}
</#if>
<#if (model_information.model_tags)?? && model_information.model_tags?has_content >
**Tags:**            ${(model_information.model_tags?join(", ","_(empty)_"))!"_(not specified)_"}
</#if>
<#if (model_information.last_modified)?? && model_information.last_modified?has_content >
**Last modified:**   ${(model_information.last_modified?datetime)!"_(not specified)_"}
</#if>
<#if (model_information.created)?? && model_information.created?has_content >
**Created:**         ${(model_information.created?datetime)!"_(not specified)_"}
</#if>
<#if (model_information.created_by)?? && model_information.created_by?has_content >
**Created by:**      ${model_information.created_by!"_(not specified)_"}
</#if>
<#if (model_information.label_column)?? && model_information.label_column?has_content >
**Label/prediction column:** ${model_information.label_column!"_(not specified)_"}
</#if>
<#if (model_information.model_type)?? && model_information.model_type?has_content >
**Model type:**      ${model_information.model_type!"_(not specified)_"}
</#if>
<#if (model_information.input_type)?? && model_information.input_type?has_content >
**Data Type:**      ${model_information.input_type!"_(not specified)_"}
</#if>
<#if (model_information.algorithm)?? && model_information.algorithm?has_content >
**Algorithm:**       ${model_information.algorithm!"_(not specified)_"}
</#if>
<#if (model_information.prediction_type)?? && model_information.prediction_type?has_content >
**Prediction Type:** ${model_information.prediction_type!"_(not specified)_"}
</#if>
<#if (model_information.software_spec)?? && model_information.software_spec?has_content >
**Software specification:** ${model_information.software_spec!"_(not specified)_"}
</#if>
</#macro>

<#------------------------------------------------------------------------------->
<#-- System Facts Report                                                       -->
<#-- Input: system_facts JSON or whole model JSON                              -->
<#-- Report output for model_information and training information              -->
<#------------------------------------------------------------------------------->
<#macro system_facts_report system_facts show_training_data_references=true ommitNameAndID=false>
<#if (system_facts)?has_content >
<@model_information_report system_facts.model_information ommitNameAndID/>
<@additional_details_model system_facts />
<@training_information_report system_facts show_training_data_references />
</#if>
</#macro>

<#------------------------------------------------------------------------------->
<#-- Physical Model Report                                                     -->
<#-- Input: physical_model JSON from model entry JSON                          -->
<#-- Currently we don't report metadata directly from physical_model           -->
<#-- but the sub-element system_facts is of course our main source             -->
<#------------------------------------------------------------------------------->
<#macro physical_model_report physical_model show_training_data_references=true ommitNameAndID=false>
<@system_facts_report physical_model.system_facts!{} show_training_data_references ommitNameAndID />
</#macro>

<#------------------------------------------------------------------------------->
<#-- Deployment                                                                -->
<#-- Input: deployment system facts, counter, alerts & status (optional)       -->
<#-- Report output for full deployment information                             -->
<#------------------------------------------------------------------------------->
<#macro deployment_report deployment counter=1 alerts=[] status="" >
<#if deployment?? && deployment?is_hash>
### Deployment #${counter}: "${deployment.name!}" 
<#if status?length != 0 >**Status**: ${status} </#if>
<#if alerts?size != 0 >**Alerts**: ${utils.color(alerts?join(", "))}</#if>

<#if (deployment.external_identifier)?? && deployment.external_identifier?has_content >
**External deployment identifier**: ${deployment.external_identifier!}
</#if>
<#if (deployment.description)?? && deployment.description?has_content >
**Description**: ${deployment.description!}
</#if>
<#if (deployment.created_on)?? && deployment.created_on?has_content >
**Created**: ${(deployment.created_on?datetime)!}
</#if>
<#if (deployment.last_modified)?? && deployment.last_modified?has_content >
**Modified**: ${(deployment.last_modified?datetime)!}
</#if>
<#if (deployment.deployment_tags)?? && deployment.deployment_tags?has_content >
**Tags**: ${(deployment.deployment_tags?join(", ","_(empty)_"))!}
</#if>
<#if (deployment.model_revision)?? && deployment.model_revision?has_content >
**Revision**: ${deployment.model_revision!}
</#if>
<#if (deployment.deployment_type)?? && deployment.deployment_type?has_content >
**Type**: ${deployment.deployment_type!}
<#elseif (deployment.type)?? && deployment.type?has_content >
**Type**: ${deployment.type!}
</#if>
<#if (deployment.deployment_copies)?? && deployment.deployment_copies?has_content >
**Copies**: ${deployment.deployment_copies!}
</#if>
<#if (deployment.scoring_urls)?? && (deployment.scoring_urls?size > 0) >
**Scoring endpoints**:
<#list deployment.scoring_urls as url>
<a href="${url}">${url}</a> <#sep>, </#sep>
</#list>
</#if>

<#if (deployment.evaluation_details)??>
### Evaluation Information
<#if (deployment.openscale_details)?? && deployment.openscale_details.service_instance_id?has_content >
**OpenScale instance ID:** ${(deployment.openscale_details.service_instance_id)!}
</#if>
<#if (deployment.openscale_details)?? && deployment.openscale_details.service_provider.name?has_content >
**OpenScale service provider:** ${(deployment.openscale_details.service_provider.name)!}
</#if>
<#if (deployment.approval_status)?? && (deployment.approval_status.state?has_content) >
**Approval status:** ${(deployment.approval_status.state)!}
</#if>
<#if (deployment.approval_status)?? && deployment.approval_status.reviewed_by?has_content >
**Reviewed by:** ${(deployment.approval_status.reviewed_by)!}
</#if>
<#if (deployment.approval_status)?? && deployment.approval_status.review_date?has_content >
**Reviewed on:** ${(deployment.approval_status.review_date?datetime)!}
</#if>
<#if (deployment.evaluation_details)?? && deployment.evaluation_details.evaluation_date?has_content >
**Last evaluation:** ${(deployment.evaluation_details.evaluation_date?datetime)!}
</#if>
<#if (deployment.evaluation_details.asset)?? && deployment.evaluation_details.asset.name?has_content >
**Evaluation data:** ${(deployment.evaluation_details.asset.name)!}
</#if>
<#if (deployment.evaluation_details.asset)?? && deployment.evaluation_details.asset.type?has_content >
**Evaluation data type:** ${(deployment.evaluation_details.asset.type)!}
</#if>

</#if>
<#if (deployment.quality)??>
### Quality Evaluation

<#assign breach_status =(deployment.quality.summary.breach_status)!"">
**Breach status:** ${utils.conditionalColor(breach_status, breach_status == "RED")}
**Records evaluated:** ${deployment.quality.records_evaluated!}

|Quality Metric|Value|
|:-------------|:----|
<#setting number_format=",##0.00">
<#list (deployment.quality.metrics?values) as metric>
|${metric.name}|${utils.conditionalColor(metric.value, (metric.breach_status?? && metric.breach_status == "RED"))}|
</#list>
<#setting number_format="" />
</#if>
<#if (deployment.fairness)??>
### Fairness Evaluation

<#assign breach_status =(deployment.fairness.summary.breach_status)!"">
**Breach status:** ${utils.conditionalColor(breach_status, breach_status == "RED")}
**Records evaluated:** ${deployment.fairness.records_evaluated!}

|Fairness Metric|Value|
|:--------------|:----|
<#list (deployment.fairness.features) as feature>
<#list (feature.metrics?values) as metric>
|${feature.name} ${metric.name}|${utils.conditionalColor((metric.value * 100)?round+ "%", ((metric.lower_limit?? && metric.value < metric.lower_limit) || (metric.upper_limit?? && metric.value > metric.upper_limit)))}|
</#list>
<#-- TODO: The following is just using the first [0] element. It probably should return the lowest scoring if the array has multiple vals -->
|${feature.name} with the lowest score|<@utils.stringOrList (feature.individual_scores[0].group_name)/>|
</#list>
</#if>
<#if (deployment.drift)??>
### Data drift Evaluation

<#assign breach_status =(deployment.drift.summary.breach_status)!"">
**Breach status:** ${utils.conditionalColor(breach_status, breach_status == "RED")}
**Records evaluated:** ${deployment.drift.records_evaluated!}

|Drift Metric|Value|
|:-----------|:----|
<#list (deployment.drift.metrics?values) as metric>
|${metric.name}|${utils.conditionalColor((metric.value * 100)?round + "%", ((metric.lower_limit?? && metric.value < metric.lower_limit) || (metric.upper_limit?? && metric.value > metric.upper_limit)))}|
</#list>
</#if>

<#if (deployment.custom_monitors)??>
<#list deployment.custom_monitors as CustomMonitor>
### ${CustomMonitor.name} Evaluation

<#assign breach_status =(CustomMonitor.summary.breach_status)!"">
<#assign breach_status =(CustomMonitor.summary.breach_status)!"">
**Breach status:** ${utils.conditionalColor(breach_status, breach_status == "RED")}

|Custom Monitor Metric|Value|
|:--------------------|:----|
<#list CustomMonitor.metrics as metric>
|${metric.name}|${utils.conditionalColor(metric.value, metric.breach_status == "RED")}|
|${metric.name}|${utils.conditionalColor(metric.value, metric.breach_status == "RED")}|
</#list>
</#list>
</#if>

</#if>
</#macro>

<#--------------------------------------------------------------------------------->
<#--------------------------------------------------------------------------------->
<#-- Section for attachment support -->
<#--------------------------------------------------------------------------------->
<#--------------------------------------------------------------------------------->

<#-- first import our custom Java-based directive for attachment downloading and embedding and publish it as macro @attachment -->
<#assign attachment_directive = "com.ibm.wkc.aigov.rest.resources.freemarker.directives.AttachmentDirective"?new()>
<#-- there is also a helper Java-based directive just for base64 encoding (e.g. to embedd logo images): publish it as macro @encode -->
<#assign encode = "com.ibm.wkc.aigov.rest.resources.freemarker.directives.EncodeDirective"?new()>
<#-- there is also a helper Java-based directive to compute th UI URL for an asset: publish it as macro @asset_url -->
<#assign asset_url = "com.ibm.wkc.aigov.rest.resources.freemarker.directives.AssetUrlDirective"?new()>

<#---------------------------------------------------------------------------------
embed_attachment (singular)
     embeds a single attachment. 
     Image attachments are embedded in base64 where possible. Simple HTML content is also directly embedded.
     - attachment: one element of the attachments JSON array from the data model 
     - skipNonEmbeddableAttachments: no output for large/complex HTML and binary files that can't be embedded into HTML. 
                                     Otherwise just ouput their name and other metadata as a list
     - displayCommentsAsCaptions: use the "comments" JSON string and output it as caption over the embedded attachment content
--------------------------------------------------------------------------------->
<#macro embed_attachment attachment, skipNonEmbeddableAttachments=true, displayCommentsAsCaptions=true downloadToFile=false showContentInline=true>
<#-- When downloading the file append id to get a unique file name -->
<#local attachment_name_with_id=attachment.name?keep_before_last(".") + "_" + attachment.id + "." + attachment.name?keep_after_last(".")>
<#if (attachment.url)?? && attachment.mime?starts_with("image") && showContentInline>
<#-- regular image files -->
<#if displayCommentsAsCaptions> <#noautoesc>Attachment Name: ${attachment.name!}</#noautoesc>
<#noautoesc>Attachment Description: ${attachment.description!}</#noautoesc></#if>
<#if downloadToFile >
<img src="data:image/png;base64,<@attachment_directive returnBase64Content=true url=attachment.url downloadFilename=attachment_name_with_id />" /> <#-- should we limit/scale to a certain size or %? -->
<#else>
<img src="data:image/png;base64,<@attachment_directive returnBase64Content=true url=attachment.url />" /> <#-- should we limit/scale to a certain size or %? -->
</#if>
<#elseif (attachment.url)?? && (attachment.mime?starts_with("text/html") || attachment.mime?starts_with("text/plain") ) && (attachment.html_rendering_hint)?? && attachment.html_rendering_hint?starts_with("inline") && showContentInline>
<#if attachment.html_rendering_hint == "inline_html" >
<#-- inline_html assumes simple, small html that can be embedded directly  -->
<#if displayCommentsAsCaptions > <#noautoesc>Attachment Name: ${attachment.name!}</#noautoesc>
<#noautoesc>Attachment Description: ${attachment.description!}</#noautoesc></#if>
<#if downloadToFile >
<#noautoesc>
<#outputformat "HTML">
<@attachment_directive returnContent=true htmlCleanup=true url=attachment.url downloadFilename=attachment_name_with_id />
</#outputformat>
</#noautoesc>
<#else>
<@attachment_directive returnContent=true htmlCleanup=true url=attachment.url /> 
</#if>
<#elseif attachment.html_rendering_hint == "inline_image" >
<#-- inline_image assumes HTML that can not be directly included - but it can be converted to an image which can be embedded  -->
<#if displayCommentsAsCaptions > <#noautoesc>Attachment Name: ${attachment.name!}</#noautoesc>
<#noautoesc>Attachment Description: ${attachment.description!}</#noautoesc></#if>
<#if downloadToFile >
<img src="data:image/png;base64,<@attachment_directive convertToImage=true returnBase64Content=true url=attachment.url downloadFilename=attachment_name_with_id />"  alt="${attachment.description!}" style="max-width:170%;" /> 
<#else>
<img src="data:image/png;base64,<@attachment_directive convertToImage=true returnBase64Content=true url=attachment.url />" alt="${attachment.description!}" style="max-width:170%;" /> 
</#if>
<#else>
${utils.color("Error")}: Unknown html_rendering_hint _${html_rendering_hint}_ 
</#if>
<#else>
<#-- The other attachments can't be embedded. They are downloaded and available as files but we can't embed them directly because of mime type/size -->
<#if !skipNonEmbeddableAttachments || !showContentInline>
<#if displayHeadingOnce> ## ${heading} <#local displayHeadingOnce=false></#if>
<#if downloadToFile>
**Name:** <a href="${attachment.name}"><@attachment_directive downloadFilename=attachment_name_with_id url=attachment.url /></a> 
**Fact Id:** ${attachment.fact_id!""}
<#else>
**Name:** ${attachment.name} 
</#if>
**Description:** ${attachment.description!""}
**Fact Id:** ${attachment.fact_id!""}
</#if>
</#if>
</#macro>

<#---------------------------------------------------------------------------------
embed_attachments (plural)
     embeds a multiple attachments from a seuence/array
     - attachments: the attachments JSON array from the data model 
     - skipNonEmbeddableAttachments: no output for large/complex HTML and binary files that can't be embedded into HTML. 
                                     Otherwise just ouput their name and other metadata as a list
     - displayCommentsAsCaptions: use the "comments" JSON string and output it as caption over the embedded attachment content
--------------------------------------------------------------------------------->
<#macro embed_attachments attachments heading skipNonEmbeddableAttachments=true displayCommentsAsCaptions=true downloadToFile=false showContentInline=true >
<#local embeddable = false />
<#list attachments as attachment >
<#if ( (attachment.url)?? && attachment.mime?starts_with("image") ) || ( ( attachment.mime?starts_with("text/html") || attachment.mime?starts_with("text/plain") )  && (attachment.html_rendering_hint)?? && attachment.html_rendering_hint?starts_with("inline") ) >
<#local embeddable = true />
</#if>
</#list>
<#if (embeddable) >
### Inline Attachments for ${heading}
</#if>
<#list attachments as attachment >
<@embed_attachment attachment skipNonEmbeddableAttachments displayCommentsAsCaptions downloadToFile showContentInline/>

</#list>
</#macro>

<#---------------------------------------------------------------------------------
embed_attachment_with_factid (singular)
     embeds a single attachment with a given factid out of the array of all attachment
     Image attachments are embedded in base64 where possible. Simple HTML content is also directly embedded.
     - attachments: the attachments JSON array from the data model 
     - factid: the fact id of one element in the attachments JSON array from the data model 
     - skipNonEmbeddableAttachments: no output for large/complex HTML and binary files that can't be embedded into HTML. 
                                     Otherwise just ouput their name and other metadata as a list
     - displayCommentsAsCaptions: use the "comments" JSON string and output it as caption over the embedded attachment content
     -  flag to force an attachment (e.g. an image) to NOT be embedded but downloaded (and put into ZIP)
     -  flag to force an attachment (e.g. an image) to BOTH be embedded AND also downloaded (and put into ZIP)
--------------------------------------------------------------------------------->
<#macro embed_attachment_with_factid attachments factid skipNonEmbeddableAttachments=true displayCommentsAsCaptions=true downloadToFile=false showContentInline=true >
<#local attachments_with_factid = attachments?filter(attachment -> attachment.fact_id == factid) />
<#if attachments_with_factid?has_content > 
<@coembed_attachment attachments_with_factid?first skipNonEmbeddableAttachments displayCommentsAsCaptions downloadToFile showContentInline />
<#else><#-- There should only be one attachment with a given id (but that is not enforced yet) -->
${utils.color("Error")}: No attachment with fact-id _${factid}_ could be found
</#if>
</#macro>

<#---------------------------------------------------------------------------------
list_attachment (singular)
     does not embed but simply output metadata for a single attachment 
     - attachment: one attachment entry out of the attachments JSON array from the data model 
     - skipEmbeddableAttachments: no output for simple HTML files and images which can be embedded into HTML. 
     - displayCommentsAsCaptions: use the "comments" JSON string and output it as caption over the embedded attachment content
     - downloadNonEmbedableAttachments: Make the content of non-embedabble attachments available by downloading them (to the download directory) in addition to listing them 
--------------------------------------------------------------------------------->
<#macro list_attachment attachment skipEmbeddableAttachments=true displayCommentsAsCaptions=true downloadNonEmbedableAttachments=false assetUrl="" >

<#local embeddable = false />
<#if (attachment.url)?? && attachment.mime?starts_with("image")>
<#-- regular image files -->
<#local embeddable = true />
<#elseif (attachment.url)?? && (attachment.mime?starts_with("text/html") || attachment.mime?starts_with("text/plain") ) && (attachment.html_rendering_hint)?? && attachment.html_rendering_hint?starts_with("inline") >
<#-- cell fact (either image or html) -->
<#local embeddable = true />
</#if>
<#-- The other attachments can't be embedded. We can include them directly because of mime type/size -->
<#if !skipEmbeddableAttachments || !embeddable >
<#if downloadNonEmbedableAttachments >
<#-- Not only download but also produce a link to the file (but it HTML will only search it in same local directory) -->
**Name:** <a href="${attachment.name}"><@attachment_directive downloadFilename=attachment.name url=attachment.url /></a> 
<#--  **Name:** <a href="${attachment.name}">${attachment.name}</a> 
${attachment.url}  -->
<#-- if the attachment has not been downloaded automatically we try to provide a link to the UI where it can be viewed and manually downloaded -->
<#elseif (assetUrl?length > 0) > <#-- if the url to the UI has been provided directly we use that -->
**Name:** <a href="${assetUrl}">${attachment.name}</a> 
<#elseif _cpdUiAssetUrl?? > <#-- if the url to the UI has been set as a global variable we use that -->
**Name:** <a href="${_cpdUiAssetUrl}">${attachment.name}</a> 
<#else> <#-- Can't provide a URL to the UI for the asset: Just show the attachment name -->
**Name:** ${attachment.name!""}
</#if>
**Comment:** ${attachment.description!""}
**FactId:** ${attachment.fact_id!""}
<#if embeddable >
**Mime:** ${attachment.mime!""}
**HTML Rendering:** ${attachment.html_rendering_hint!""}
</#if>
</#if>
</#macro>

<#---------------------------------------------------------------------------------
list_attachments (plural)
     does not embed but simply outputs metadata for all attachments
     - attachments: the attachments JSON array from the data model 
     - skipEmbeddableAttachments: no output for simple HTML files and images which can be embedded into HTML. 
     - displayCommentsAsCaptions: use the "comments" JSON string and output it as caption over the embedded attachment content
     - downloadNonEmbedableAttachments: Make the content of non-embedabble attachments available by downloading them (to the download directory) in addition to listing them 
--------------------------------------------------------------------------------->
<#macro list_attachments attachments heading skipEmbeddableAttachments=false displayCommentsAsCaptions=true downloadNonEmbedableAttachments=false assetUrl="" >
<#local nonembeddable = false />
<#list attachments as attachment >
<#if ( (attachment.url)?? && !attachment.mime?starts_with("image") ) && ( !(attachment.html_rendering_hint)?? ) >
<#local nonembeddable = true />
</#if>
</#list>
<#if (nonembeddable) >
### File Attachments for ${heading}
</#if>
<#list attachments as attachment >
<@list_attachment attachment skipEmbeddableAttachments displayCommentsAsCaptions downloadNonEmbedableAttachments assetUrl />

</#list>
</#macro>

<#---------------------------------------------------------------------------------
list_attachment_with_factid (singular)
     does not embed but simply output metadata for a single attachment referenced by its factid
     - attachments: the attachments JSON array from the data model 
     - factid: the fact id of one element in the attachments JSON array from the data model 
     - skipEmbeddableAttachments: no output for simple HTML files and images which can be embedded into HTML. 
     - displayCommentsAsCaptions: use the "comments" JSON string and output it as caption over the embedded attachment content
     - downloadNonEmbedableAttachments: Make the content of non-embedabble attachments available by downloading them (to the download directory) in addition to listing them 
--------------------------------------------------------------------------------->
<#macro list_attachment_with_factid attachments factid skipEmbeddableAttachments=true displayCommentsAsCaptions=true  downloadNonEmbedableAttachments=false>
<#list attachments as attachment >
<#if attachment.fact_id == factid > <#-- There should only be one attachment with a given id (but that is not enforced yet) -->
<@list_attachment attachment skipEmbeddableAttachments displayCommentsAsCaptions downloadNonEmbedableAttachments />
</#if>
</#list>
</#macro>

<#macro branding_logo logo>
<#if (logo.report_logo)?? >
<img src="data:image/png;base64,<@attachment_directive returnBase64Content=true url=logo.report_logo />" width="100" height="100" style="float:right"/>
<#else>
<img src="data:image/png;base64,${logo.default_logo}" width="150" height="100" style="float:right"/>
</#if>
</#macro>

<#macro model_entry_approaches approaches>
#### Approaches used in this model use case

|Approach name|Description|
|:------------|:----------|
<#list approaches as approach >
|${approach.name}|${approach.description}|
</#list>
</#macro>

<#macro model_version_details version_information>
<#if version_information.approach_name?has_content >
**Approach name:** ${version_information.approach_name!}
</#if>
<#if version_information.approach_description?has_content >
**Approach description:** ${version_information.approach_description!}
</#if>
<#if version_information.version_number?has_content >
**Model version:** ${version_information.version_number!}
</#if>
<#if version_information.version_comment?has_content >
**Model version comment:** ${version_information.version_comment!}
</#if>
</#macro>
<#---------------------------------------------------------------------------------
----------------------------------------------------------------------------------->
<#-- Unused - delete later once we decide to not pursue this approach to report/module metadata
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
