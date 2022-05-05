$subscription = ""
$aksname = ""
$rg = ""
$acrname = ""

# set subscription context
az account set --subscription $subscription

#link ACR to AKS
az aks update --name $aksname --resource-group $rg --attach-acr $acrname

#login to ACR so docker push will work
az acr login --name $acrname