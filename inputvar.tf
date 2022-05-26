variable "rsg" {
    description = "contains the resource group name where the AKS cluster is to be built"
    type = string
    default = "abintest-rsg" 
}

variable "client" {
    description = "contains the client name for whom the AKS Cluster is built"
    type = string 
    default = "lexdemo"
}

variable "ssh_public_key" {
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes" 
  type = string  
}

variable "ssh_private_key" {
  default = ".ssh/aks-ssh-keys/akssshkey"
  description = "This variable defines the SSH private key"
  type = string   
}

# Windows Admin Username for k8s worker nodes
variable "windows_admin_username" {
  type = string
  default = "azureuser"
  description = "This variable defines the Windows admin username k8s Worker nodes"  
}

# Windows Admin Password for k8s worker nodes
variable "windows_admin_password" {
  type = string
  default = "Eastbengal@12345"
  description = "This variable defines the Windows admin password k8s Worker nodes"  
}

variable "hostname" {
  type = string
  default = "dockerhost"
}

variable "visibility" {
    description = "contains the visibility for the ado project"
    type = string 
    default = "private"
}

variable "ado_org_service_url" {
    description = "contains the URL of your devops org"
    type = string
    default = "https://dev.azure.com/aduttagupta"
}

variable "ado_github_repo" {
  type        = string
  description = "Name of the repository in the format <GitHub Org>/<RepoName>"
  default     = "abindg/ADO-Terraform-AKS-ACR-K8s"
}

variable "ado_pipeline_yaml_path_1" {
  type        = string
  description = "Path to the yaml for the child pipeline"
  default     = "docker-build.yaml"
}

variable "pipelinename" {
  type = string
  description = "Contains the pipeline name"
  default = "terraform-docker-push"
}
