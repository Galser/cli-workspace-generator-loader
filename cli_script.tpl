#!/usr/bin/env bash

%{ for ws in workspaces ~}
# ---
# Workspace  ${ws}
  mkdir -p ${codes_folder}/${ws}
  pushd ${codes_folder}/${ws}
  cp ../../${test_code_repo_folder}/*.tf .
  terraform init
  sleep 1
  terraform apply --auto-approve
  popd
%{ endfor ~}

