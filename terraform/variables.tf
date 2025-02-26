variable "environment" {
  description = "Name of environment. Used as AKS cluster name and as a prefix to all resource names"
  type        = string

  validation {
    condition     = length(var.environment) > 4
    error_message = "The environment name needs to be longer than 4 characters."
  }
}

variable "location" {
  description = "Name of Azure location in which to create resources (required)"
  type        = string
}

variable "admin_username" {
  description = "Username of the local administrator to be created on the Kubernetes cluster"
  type        = string
  default     = "azureuser"
}

variable "creator" {
  description = "Email address / user ID of the person creating the environment (required)"
  type        = string
}

variable "vnet_cidr" {
  description = "Overall virtual network CIDR address space (required)"
  type        = string
}

variable "vnet_subnet_cidr" {
  description = "Subnet CIDR prefix inside virtual network address space (required)"
  type        = string
}

variable "aks_service_cidr" {
  description = "Service network CIDR for AKS cluster (required)"
  type        = string
}

variable "aks_dns_service_ip" {
  description = "DNS service IP for AKS cluster (required)"
  type        = string
}

variable "aks_docker_cidr" {
  description = "Docker overlay network CIDR for AKS cluster (required)"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to use in AKS cluster (optional - defaults to 1.19.7)"
  type        = string
  default     = "1.19.7"
}
variable "public_ssh_key" {
  description = "Provide SSH public key value or file name to be used to access the cluster's nodes (required)"
  type        = string
}

variable "aks_core_pool" {
  description = "Core node pool (agents) of the AKS cluster and its configutation (optional)"
  type        = map(any)
  default = {
    name      = "core",
    vm_size   = "Standard_D4s_v3",
    min_count = 1,
    max_count = 3,
    disk_size = 100
  }
}

variable "storage_logging_enabled" {
  description = "Enable Azure storage logging (optional - default to false / disabled)"
  type        = bool
  default     = false
}

variable "storage_logging_retention" {
  description = "Number of days to keep storage logs, if enabled (optional - default to 7 days)"
  type        = number
  default     = 7
}

variable "backup_retention" {
  description = "Number of days to keep Splice DB backups (optional - defaults to 14 days)"
  type        = number
  default     = 14
}

variable "aks_admin_group" {
  description = "AD Admin Group to add to the AKS configuration for Admin"
  type        = string
}
