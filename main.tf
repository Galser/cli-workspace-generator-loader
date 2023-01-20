# VARIABLES
# We putting them here as we want to have ON code file for thw hole test
# ---


# Variables

# GitHub repo fro testing
variable "repo_identifier" {
  default = "Galser/tf-large-state-generator-a"
}


resource "random_pet" "org" {}

resource "random_pet" "workspace" {}

# LOCALS
locals {
  organization_name   = random_pet.org.id
  workspace_to_create = random_pet.workspace.id
  resources_count     = var.workspace_count
}

provider "tfe" {
  hostname = var.tfe_hostname
  #  token    = var.token. --> oinly if we really want it
  #  for the test we assume it is coming from TFE_TOKEN env var
  #  version  = "~> 0.15.0"
}

# RESOURCES 

resource "tfe_organization" "test" {
  name  = local.organization_name
  email = var.admin_email
}


# Creating workspace(s)
resource "tfe_workspace" "ws-test-main" {
  count = local.resources_count
  #   name         = ${local.workspace_to_create} + "_"+"${count.index}"
  # agent_pool_id  = local.agent_pool_id 
  name           = format("%s_%03d", local.workspace_to_create, count.index)
  organization   = tfe_organization.test.id
  auto_apply     = true
  queue_all_runs = true
  execution_mode = "remote" # "remote" # agent
}

locals { 
  workspaces = toset([for w in tfe_workspace.ws-test-main[*] : tostring(w.id) ])
  # [for w in tfe_workspace.ws-test-main[*] : tostring(w.id) ]
}


resource "local_file" "cloud_config" {
#  for_each = tfe_workspace.ws-test-main[*].id
  for_each = local.workspaces
  content  = templatefile("${path.module}/cloud_config.tpl", {  tfe_organization = tfe_organization.test.id,  tfe_hostname = var.tfe_hostname, workspace = each.value})
  filename = "${path.module}/${var.codes_folder}/${each.value}/cloud_config.tf"
}

resource "local_file" "saved_cli_applies_script" {
  content  = templatefile("${path.module}/cli_script.tpl", { workspaces = [for w in tfe_workspace.ws-test-main[*] : tostring(w.id) ], test_code_repo_folder = var.test_code_repo_folder, codes_folder = var.codes_folder} )

  filename = "${path.module}/generate_runs.sh"
}