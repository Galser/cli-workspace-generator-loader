# api-workspace-generator-loader
Generator for API-driven workspaces to create some load or and storage testing

This project will alow you to create some (large) amount of workspaces that are CLI-backed by my some GitHub repo,  and (potentially) attach them into agent pools

# How to use

1. Define required variables (see section below)
2. Run `terraform apply`
3. Enjoy!

# Requirements

Define following environment variables before run : 

- **TFE_TOKEN** - token for authentication to TFE ( preferrably user level)
- **TF_VAR_github_auth_token** - token for authentication to the GitHub account, if you need it

Also please define following variables in the `terraform.tfvars` : 

- *tfe_hostname*  - hostname of TFE instance
- *admin_email* - email for admin user
- *workspace_count* - workspaces count to create
- *test_code_repo_folder* - some repo with code to run in the tested workspaces

# Run apply to create org and workspaces

Run `terrafrom apply` and wait for applies to finish or ..well, proceed with your tasks

As a result of succesfull run a file with name `generate_runs.sh`  should be generated along 
with a folder, named by default TFF, that contains set of sub-folders with configuratiosn for 
CLI-initiated runs


# Create all configs and initate CLI runs by executing `generate_runs.sh`


Run `generate_runs.sh` to create and upload configurations for every workspace and initiate runs.


