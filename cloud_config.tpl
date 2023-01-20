terraform {
  cloud {
    organization = "${tfe_organization}"
    hostname = "${tfe_hostname}"

    workspaces {
      name = "${workspace}"
    }
  }
}
