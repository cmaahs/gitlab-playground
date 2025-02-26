# Environment/Cluster Name
environment = "gitlab-git"

# Azure location
location = "northcentralus"

# Tag 'Creator'
creator = "cmaahs@outlook.com"

# Overall CIDR address space for the environment
vnet_cidr = "10.192.192.0/19"

# CIDR for vnet subnet
vnet_subnet_cidr = "10.192.196.0/22"

# Service subnet CIDR for AKS cluster
aks_service_cidr = "10.192.228.0/22"

# DNS service IP address for AKS cluster
aks_dns_service_ip = "10.192.228.10"

# Docker overlay subnet CIDR for AKS cluster
aks_docker_cidr = "10.192.232.1/22"

# Version of Kubernetes to us
kubernetes_version = "1.24.10"

# Public Key for Node Group Nodes
public_ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwGgz9pGGOya2PTfla/551bqoBrBapSMiP9rK+3epwUerhRKK7ITEwDdMF2rgC52H+YdXy4QMyvkba+0Qc4S0nHDRYP1mGeJ7ynnX/WBX4QSatUu2aY7ieLpXSz8TsAODBZImJYY/ZFD63k7h4ng9wbzQb17gkxhCK0JbXh+NcS4Ovfv6dHdQusxLXWVZB/hgEMBLbkCNjpu3293xX57x0QsVkiixKAXXECX8XNkngoLz9lizKVtEqHUNbZzMEKw4NS5SgTsY3ZeZnQLDmCdKX01HfUiZAyJouxGav9laBWfUIW2ILPXKhlzIGlZ+Z8h1+7Q9uV8cctiW1lkLxydZ6+qzeNCXwRxQ/m21Rfn65vU6jSBjW21wsTxKJMeBCft0Lt6axjA4IkLvBMC3eqWaA7/Kfvv1gK0jm2I0ghKPLUotjdp8yysLZZp0z2Oab4vRCXGYGEwO41voxyhxfH5eowEeHOJjGE3+MGtbUIc1HSN2X7tTamd5NyLGEpeBm4iQQC9yTxg5jWhbXopNAr27KaXkSuQWLwe+viPqBvvCFPmC2GE0J3LCK2ykppX5oXpsBKy7kECX4W2N5N1hisZWOgkBq/TSraJzYpz+uDZ89V2gWNvX6AHkSDOpeGi82W+iMD3Y+Q4LNzhckAAxyZyGY7d0eKy12k6Sbp8Te1AhDCQ== cmaahs@gmail.com"

# Core node pool for the AKS cluster (default value)
aks_core_pool = {
  name      = "core",
  vm_size   = "Standard_D2_v3",
  min_count = 3,
  max_count = 5,
  disk_size = 64
}

# Name of Azure AD group that should have administrative rights to the AKS cluster
aks_admin_group = "Cloud_Engineering"
