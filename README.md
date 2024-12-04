# IBM AI Factsheet Governance Samples

**Internal repository** for sample models, notebooks, and applications related to AI Governance Factsheets.

## Overview

**IBM AI Factsheet** is a component of **watsonx.governance**. It provides a systematic approach to collecting and managing facts about machine learning models. The `ibm_aigov_facts_client` is a Python SDK designed to collect and manage facts about models, including gathering details from external models and prompts throughout their development lifecycle.

Our Python client library facilitates the collection of facts from various experiments conducted within Jupyter notebooks, whether hosted on IBM Cloud, external Machine Learning Engines, or in standalone environments.

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

| Notebook                            | Description                                                  | Cloud | CPD 4.8x | CPD 5.0x |
| :---------------------------------- | :--------------------------------------------------------- | :---: | :-----: | :-----: |
| End-to-End Workflow Notebook        | Demonstrates all features provided by IBM AI Factsheet    | [link](https://github.com/LakshmiN5/ai-governance-factsheet-samples_public/blob/466b11175a129bc0100eeb96bd90132f6faf4bce/cloud/End%20To%20End%20Flow/End-to-End%20Workflow%20IBM%20Cloud.ipynb) | [link](link2) | [link](3) |
| Inventory Management Notebook        | Demonstrates  managing inventories across various platforms. It includes detailed instructions for creating, updating, and managing inventories, as well as handling collaborator roles.   | [link](1) | [link](link2) | [link](3)  |
| AI-usecase Approaches Notebook   |Create and manage models and AI use cases, showcasing various approaches and versioning (Major, Minor, Patch) for effective model tracking..   | [link](1) | [link](link2) | [link](3)  |

## External Model Notebooks

 This section demonstrate creating, listing, managing external models, deploying, and managing lifecycle phases for external models in IBM watsonx.governance.
 
 | Notebook                            | Description                                                  | Cloud | CPD 4.8x | CPD 5.0x |
| :---------------------------------- | :--------------------------------------------------------- | :---: | :-----: | :-----: |
| Getting Started with External Model in IBM Factsheet    | Demonstrates all features for external model provided by IBM AI Factsheet    | [link](1) | [link](link2) | [link](3) |



## Prompt Notebooks

 This section covers managing prompt template assets for Language Models (LLMs) across various platforms, including:

- Detached Prompts: Prompt on Third-Party Platforms Such as AWS Bedrock and Azure.
- Standard Prompts: Created directly within the watsonx.ai platform.
 
 | Notebook                            | Description                                                  | Cloud | CPD 5.0x |
| :---------------------------------- | :--------------------------------------------------------- | :---: | :-----: |
| End-to-End Detached PTA with Evalution    | Demonstrates entire workflow, from the creation of prompt template assets to their evaluation, ensuring a thorough understanding of both the setup and assessment phases.   | [link](1) | [link](2) |
| Getting Started with Regular Prompt Notebook in IBM Factsheet  | Demonstrates  insights into the management and utilization of these prompt templates    | [link](1) | [link](2) |

 
 




