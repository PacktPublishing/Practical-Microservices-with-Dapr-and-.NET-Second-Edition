$subscription = ""
$aksname = ""
$rg = ""
$location = ""

az account set --subscription $subscription

# create RG
az group create --name $$rg  --location $location

# create AKS --- no cluster autoscaler https://docs.microsoft.com/en-us/azure/aks/start-stop-cluster  
az aks create --resource-groue $rg --name $askname  `
    --node-count 3 --node-vm-size Standard_D2s_v3 `
    --enable-addons monitoring `
    --vm-set-type VirtualMachineScaleSets `
    --generate-ssh-keys

# stop AKS --- https://docs.microsoft.com/en-us/azure/aks/start-stop-cluster
az aks stop --name $askname --resource-groue $rg
az aks show --name $askname  --resource-groue $rg

# start AKS --- https://docs.microsoft.com/en-us/azure/aks/start-stop-cluster 
az aks start --name $askname --resource-groue $rg
az aks show --name $askname --resource-groue $rg

# kubectl CLI
az aks install-cli

# access AKS
az aks get-credentials --name $askname --resource-groue $rg
# query AKS
kubectl get nodes
