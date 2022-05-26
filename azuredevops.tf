/*
resource "azuredevops_project" "project" {
  name               = "${var.client}-app-deployment"
  description        = "This project is meant to hold pipelines for deploying ${var.client} related applications"
  visibility         = var.visibility
  version_control    = "Git"   # This will always be Git for me
  work_item_template = "Agile" # Not sure if this matters, check back later

  features = {
    # Only enable pipelines for now
    "testplans"    = "disabled"
    "artifacts"    = "disabled"
    "boards"       = "disabled"
    "repositories" = "disabled"
    "pipelines"    = "enabled"
  }
}
*/
data "azuredevops_project" "existing" {
  name = "ADO-Terraform-AKS-ACR-K8s"
}

resource "azuredevops_serviceendpoint_github" "serviceendpoint_github" {
  project_id            = data.azuredevops_project.existing.id
  service_endpoint_name = "abindg"
}

/*
resource "azuredevops_resource_authorization" "auth" {
  project_id  = data.azuredevops_project.existing.id
  resource_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  authorized  = true
}
*/

resource "azuredevops_serviceendpoint_azurecr" "acr-sc" {
  project_id                = data.azuredevops_project.existing.id
  service_endpoint_name     = "${var.client}acr-sc"
  resource_group            = data.azurerm_resource_group.rsg1.name
  azurecr_spn_tenantid      = data.azurerm_subscription.current.tenant_id
  azurecr_name              = azurerm_container_registry.acr.name
  azurecr_subscription_id   = data.azurerm_subscription.current.subscription_id
  azurecr_subscription_name = data.azurerm_subscription.current.display_name
}

resource "azuredevops_resource_authorization" "acrauth" {
  project_id  = data.azuredevops_project.existing.id
  resource_id = azuredevops_serviceendpoint_azurecr.acr-sc.id
  authorized  = true
}

resource "azuredevops_serviceendpoint_kubernetes" "akssc" {
  for_each = {
    "devenv" = "dev"
    "qaenv" = "qa"
  }
  depends_on = [
    azurerm_role_assignment.aksroleassign
  ]
  project_id            = data.azuredevops_project.existing.id
  service_endpoint_name = "${var.client}-${each.value}-aks-sc"
  apiserver_url         = "https://${azurerm_kubernetes_cluster.aks.fqdn}"
  authorization_type    = "AzureSubscription"

  azure_subscription {
    subscription_id   = data.azurerm_subscription.current.subscription_id
    subscription_name = data.azurerm_subscription.current.display_name
    tenant_id         = data.azurerm_subscription.current.tenant_id
    resourcegroup_id  = data.azurerm_resource_group.rsg1.name
    namespace         = each.value
    cluster_name      = azurerm_kubernetes_cluster.aks.name
  }
}

resource "azuredevops_resource_authorization" "aksauth" {
  for_each = {
    "devenv" = "dev"
    "qaenv" = "qa"
  }
  project_id  = data.azuredevops_project.existing.id
  resource_id = azuredevops_serviceendpoint_kubernetes.akssc[each.key].id
  authorized  = true
}



resource "azuredevops_variable_group" "variablegroup" {
  project_id   = data.azuredevops_project.existing.id
  name         = "${var.client}-app-deployment"
  description  = "Variable group for ${var.client} pipelines"
  allow_access = true

  variable {
    name  = "acrname"
    value = azurerm_container_registry.acr.name
  }

  variable {
    name  = "reponame"
    value = "${var.client}app"
  }

  variable {
    name = "acrsc"
    value = "${azuredevops_serviceendpoint_azurecr.acr-sc.service_endpoint_name}"
  }

 variable {
    name = "akssc-dev"
    value = "${azuredevops_serviceendpoint_kubernetes.akssc["devenv"].service_endpoint_name}"
  } 

variable {
    name = "akssc-qa"
    value = "${azuredevops_serviceendpoint_kubernetes.akssc["qaenv"].service_endpoint_name}"
  }

variable {
    name = "Dev_Env"
    value = "dev"
}

variable {
    name = "QA_Env"
    value = "qa"
}

variable {
  name = "image_name"
  value = local.image_name
}

variable {
  name = "client_name"
  value = var.client
}

}

resource "azuredevops_build_definition" "pipeline_1" {

  depends_on = [
               azuredevops_resource_authorization.acrauth
                ]
  project_id = data.azuredevops_project.existing.id
  name       = var.pipelinename

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type             = "GitHub"
    repo_id               = var.ado_github_repo
    branch_name           = "main"
    yml_path              = var.ado_pipeline_yaml_path_1
    service_connection_id = azuredevops_serviceendpoint_github.serviceendpoint_github.id
  }
}
