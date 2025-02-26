# Powershell to Create a Let's Encrypt Wildcard Certificate

```powershell
#/usr/bin/env pwsh

function Prompt { "> " }
Get-Module -ListAvailable
Import-Module Posh-ACME
Import-Module Base64

$ContactInfo="cmaahs@maahsome.rocks"
$LEServer="LE_PROD"
$AccountId=""                   # need to set this
$pasrv = Get-PAServer
if ( ! $pasrv ) { Set-PAServer $LEServer }

#
$acct = Get-PAAccount -ID $AccountId
if ( ! $acct ) { $acct = New-PAAccount -Contact $ContactInfo -AcceptTOS }
Get-PACertificate -List | Format-Table -AutoSize

$cert =  $cert = Get-PACertificate "*.maahsome.rocks"
if ( $cert ) {
  Set-PAOrder "*.maahsome.rocks"
  $newCert = Submit-Renewal
} else {
  $newCert = New-PACertificate "*.maahsome.rocks" -AcceptTOS -Contact $ContactInfo
}
Write-Output $newCert
Get-PACertificate -List | Format-Table -AutoSize
$tlsCrt = Get-Content $newCert.FullChainFile -Raw | ConvertTo-Base64String
$tlsKey = Get-Content $newCert.KeyFile -Raw | ConvertTo-Base64String
$tlsCrt | Out-File -Path ./maahsome.crt
$tlsKey | Out-File -Path ./maahsome.key
}
```

```zsh
GIT_HOST=git # git|lab|argocd
ky get secret/maahsome-rocks-tls -n ${GIT_HOST} > maahsome-rocks-tls.yaml
yq e -i ".data.\"tls.crt\" = \"$(cat ./maahsome.crt)\"" maahsome-rocks-tls.yaml
yq e -i ".data.\"tls.key\" = \"$(cat ./maahsome.key)\"" maahsome-rocks-tls.yaml
k apply -f maahsome-rocks.tls.yaml -n ${GIT_HOST}
```
