
# .Scripts
Scripts is compose of automation related codebase such as Pipeline as code, Infrastructure as Code and other utility automation

## Infrastructures
Infrastructure as Code (IoC) – ARM, Bicep, Pulumi, Scripts and Terraform files, including shared.
## Pipelines
YAML build and release pipeline definitions and all pipeline variables

## utilities
Other Automation that are uncategorize

# Docs
This folder is the location of all Wiki and Documentation such as Architecture Design Record(ADR), Resources , Assets , Etc

# Samples
This folder is intended how to use the codebase and its corresponding usecase/implementation

# Src
For the /src (code source) folder, I like to have a top-level templates area with sample projects and files. Code re-use should be encouraged as much as possible. To facilitate the widest possible re-use, I add a ‘common’ folder at the top level and at every other level in the org-platform-app hierarchy. The higher up the hierarchy a component can sit the better and designing to this principal should be encouraged.

# Tests
Automated, integration and other test assets such as Postman collections and Selenium scripts.

AB#128
#Referrence
* https://nicholasrogoff.com/2023/09/21/mono-repository-folder-structures/
