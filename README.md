# IBM AI Factsheet Governance Samples

Repository for sample models, notebooks, and applications related to AI Governance Factsheets.

## Overview

**IBM AI Factsheet** is a component of **watsonx.governance**. It provides a systematic approach to collecting and managing facts about machine learning models. The `ibm_aigov_facts_client` is a Python SDK designed to collect and manage facts about models, including gathering details from external models and prompts throughout their development lifecycle.

Our Python client library facilitates the collection of facts from various experiments conducted within Jupyter notebooks, whether hosted on IBM Cloud, external Machine Learning Engines, or in standalone environments.

## Installation
To install the IBM AI Governance Facts Client, ensure Python 3.7 or later is installed. Then, use pip:

```
 pip install ibm-aigov-facts-client
```
The package automatically installs required dependencies

## Client Initialization
To initialize the client, follow these guidelines:

Container Type: Choose either space or project. Note that environment utilities (get/set) require the model asset to be stored in a Space.
Experiment Management: If re-running the notebook with the same experiment name or encountering errors like Experiment with same name already exists, set set_as_current_experiment=True during client initialization.
use_software Parameter: Set use_software=True if using IBM watsonx.governance software, or False if using IBM Cloud.

Example:
```
if use_software:
    facts_client = AIGovFactsClient(
        cloud_pak_for_data_configs=creds,
        experiment_name=experiment_name,
        container_type=container_type,
        container_id=container_id,
        set_as_current_experiment=True
    )
else: 
    facts_client = AIGovFactsClient(
        api_key=API_KEY,
        experiment_name=experiment_name,
        container_type=container_type,
        container_id=container_id,
        set_as_current_experiment=True
    )
```

### Region Specification
To use the IBM AI Gov Facts Client in different regions, specify the region where watsonx.governance is hosted. Examples for Frankfurt and Sydney:

Sample Code:

- Sydney

```
from ibm_aigov_facts_client import AIGovFactsClient, CloudPakforDataConfig

client = AIGovFactsClient(
    api_key=<API_KEY>,
    experiment_name=<experiment_name>,
    container_type="space or project",
    container_id=<space_id or project_id>,
    region="sydney"
)
```
- Frankfurt
```from ibm_aigov_facts_client import AIGovFactsClient, CloudPakforDataConfig

client = AIGovFactsClient(
    api_key=<API_KEY>,
    experiment_name=<experiment_name>,
    container_type="space or project",
    container_id=<space_id or project_id>,
    region="frankfurt"
)
```

# Notebooks Guidance
## End-to-End Workflow Notebooks

This section demonstrates the creation of a machine learning model while covering all features provided by IBM AI Factsheets, such as:
- Trace and Customize Training Run
- Export Training Facts
- Inventory Management
- Additional Training Information
- Custom Facts
- Capture Cell Facts
- Associate Workspaces
- Governing AI Assets
- AI usecase Approaches 

| Notebook                            | Description                                                  |                                                                                                                                                                         Cloud                                                                                                                                                                         |                                                                                                     CPD 4.8x                                                                                                      |                                                                                                        CPD 5.0x                                                                                                         |
| :---------------------------------- | :--------------------------------------------------------- |:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| End-to-End Workflow Notebook        | Demonstrates all features provided by IBM AI Factsheet    |                                                                                  [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud/End%20To%20End%20Flow/End-to-End%20Workflow%20IBM%20Cloud.ipynb)                                                                                   | [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud_pak_for_data/4.8x%20Version/End%20To%20End%20Flow/End-to-End%20Workflow%204.8x%20Edition.ipynb) | [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud_pak_for_data/5.0x%20Version/End%20To%20End%20Flow/End-to-End%20Workflow%205.0x%20Edition.ipynb.ipynb) |
| Inventory Management Notebook        | Demonstrates  managing inventories across various platforms. It includes detailed instructions for creating, updating, and managing inventories, as well as handling collaborator roles.   |                                                                                   [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud/End%20To%20End%20Flow/Inventory%20Notebook%20IBM%20Cloud.ipynb)                                                                                   |                                                                                                        NA                                                                                                         |                                                                                                           NA                                                                                                            |
| AI-usecase Approaches Notebook   |Create and manage models and AI use cases, showcasing various approaches and versioning (Major, Minor, Patch) for effective model tracking..   |                                                                                                                                                                       [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud/End%20To%20End%20Flow/AI-usecase%20Approach%20IBM%20Cloud.ipynb)                                                                                                                                                                        |                                                                                                   [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud_pak_for_data/4.8x%20Version/End%20To%20End%20Flow/AI-usecase%20Approach%204.8x%20Edition.ipynb)                                                                                                   |                                                                                                        [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud_pak_for_data/5.0x%20Version/End%20To%20End%20Flow/AI-usecase%20Approach%205.0x%20Edition.ipynb)                                                                                                         |

## External Model Notebooks

With watsonx.governance or AI Factsheets, you can manage models created outside IBM Cloud Pak for Data, including those from platforms like AWS or Azure. These tools allow you to track model performance and evaluation results in detailed factsheets, ensuring compliance and transparency. 

This section demonstrate creating, listing, managing external models, deploying, and managing lifecycle phases for external models in IBM watsonx.governance.
 
 | Notebook                            | Description                                                  |  Cloud   | CPD 4.8x | CPD 5.0x |
| :---------------------------------- | :--------------------------------------------------------- |:--------:| :-----: |:--------:|
| Getting Started with External Model in IBM Factsheet    | Demonstrates all features for external model provided by IBM AI Factsheet    | [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud/External%20Model/External%20Model%20with%20wx.goverance%20IBM%20Cloud.ipynb) | [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud_pak_for_data/4.8x%20Version/External%20Model/External%20Model%20with%20wx.goverance%204.8.x.ipynb) | [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud_pak_for_data/5.0x%20Version/External%20Model/External%20Model%20with%20wx.goverance%205.0x.ipynb) |



## Prompt Notebooks

 This section covers managing prompt template assets for Language Models (LLMs) across various platforms, including:

- Detached Prompts: Prompt on Third-Party Platforms Such as AWS Bedrock and Azure.
- Standard Prompts: Created directly within the watsonx.ai platform.
 
 | Notebook                            | Description                                                  |                                                                                             Cloud                                                                                             | CPD 5.0x |
| :---------------------------------- | :--------------------------------------------------------- |:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:--------:|
| End-to-End Detached PTA with Evalution    | Demonstrates entire workflow, from the creation of prompt template assets to their evaluation, ensuring a thorough understanding of both the setup and assessment phases.   | [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud/Prompt/End-to-End%20Detached%20PTA%20with%20Evalutions%20IBM%20Cloud.ipynb) | [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud_pak_for_data/5.0x%20Version/Prompt/End-to-End%20Detached%20PTA%20with%20Evalutions%205.0x.ipynb) |
| Getting Started with Regular Prompt Notebook in IBM Factsheet  | Demonstrates  insights into the management and utilization of these prompt templates    |                                                                                           [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud/Prompt/Prompt%20Notebook%20with%20wx.goverance%20IBM%20Cloud.ipynb)                                                                                            | [link](https://github.com/IBM/ai-governance-factsheet-samples/blob/4082dfd199b9ba2c3a5a87f3a93519c8c1c1563f/cloud_pak_for_data/5.0x%20Version/Prompt/Prompt%20Notebook%20with%20wx.goverance%205.0x.ipynb) |

 
 




