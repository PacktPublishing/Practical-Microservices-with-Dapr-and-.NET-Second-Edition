# replace value before starting
$CONTAINERAPPS_ENVIRONMENT = ""
$RESOURCE_GROUP = ""
$APPLICATIONINSIGHTS_NAME = ""
$LOG_ANALYTICS_WORKSPACE = ""
$LOCATION = ""
$COMPONENT_PATH = ""
# the following script deploy Azure Container Apps using images from the public Docker Hub repository
$REGISTRY_NAME = "davidebedin"
# if you instead choose to import container images from Docker Hub into Azure Container Registry 
# or use container images pushed to Azure Container Registry, you need to provide credentials
# see https://learn.microsoft.com/en-us/azure/container-apps/get-started-existing-container-image?tabs=bash&pivots=container-apps-private-registry

$LOG_ANALYTICS_WORKSPACE_CLIENT_ID=(az monitor log-analytics workspace show --query customerId -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv)
$LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=(az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE -o tsv)
$APPLICATIONINSIGHTS_KEY = (az resource show -g $RESOURCE_GROUP -n $APPLICATIONINSIGHTS_NAME --resource-type "microsoft.insights/components" --query properties.InstrumentationKey -o tsv)

# https://docs.microsoft.com/en-us/azure/container-apps/get-started-existing-container-image?tabs=powershell&pivots=container-apps-public-registry
az extension add --name containerapp --upgrade
az provider register --namespace Microsoft.App

az containerapp env create `
--name $CONTAINERAPPS_ENVIRONMENT `
--resource-group $RESOURCE_GROUP `
--dapr-instrumentation-key $APPLICATIONINSIGHTS_KEY `
--logs-workspace-id $LOG_ANALYTICS_WORKSPACE_CLIENT_ID `
--logs-workspace-key $LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET `
--location $LOCATION 
 
az containerapp env dapr-component set `
--name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP `
--dapr-component-name commonpubsub `
--yaml ($COMPONENT_PATH + "component-pubsub.yaml")

az containerapp env dapr-component set `
--name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP `
--dapr-component-name orderstore `
--yaml ($COMPONENT_PATH + "component-orderstore.yaml")

az containerapp env dapr-component set `
--name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP `
--dapr-component-name reservationstore `
--yaml ($COMPONENT_PATH + "component-reservationstore.yaml")

az containerapp env dapr-component set `
--name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP `
--dapr-component-name reservationitemactorstore `
--yaml ($COMPONENT_PATH + "component-reservationitemactorstore.yaml")

az containerapp env dapr-component set `
--name $CONTAINERAPPS_ENVIRONMENT --resource-group $RESOURCE_GROUP `
--dapr-component-name customizationstore `
--yaml ($COMPONENT_PATH + "component-customizationstore.yaml")

az containerapp create `
  --name t1-reservationactor `
  --resource-group $RESOURCE_GROUP `
  --environment $CONTAINERAPPS_ENVIRONMENT `
  --image ($REGISTRY_NAME + "/sample.microservice.reservationactor:2.0") `
  --target-port 80 `
  --ingress 'internal' `
  --min-replicas 1 `
  --max-replicas 1 `
  --cpu 0.25 `
  --memory 0.5 `
  --enable-dapr `
  --dapr-app-port 80 `
  --dapr-app-id reservationactor-service

az containerapp create `
  --name t1-reservation `
  --resource-group $RESOURCE_GROUP `
  --environment $CONTAINERAPPS_ENVIRONMENT `
  --image ($REGISTRY_NAME + "/sample.microservice.reservation:2.0") `
  --target-port 80 `
  --ingress 'internal' `
  --min-replicas 1 `
  --max-replicas 1 `
  --cpu 0.25 `
  --memory 0.5 `
  --enable-dapr `
  --dapr-app-port 80 `
  --dapr-app-id reservation-service 

az containerapp create `
  --name t1-customization `
  --resource-group $RESOURCE_GROUP `
  --environment $CONTAINERAPPS_ENVIRONMENT `
  --image ($REGISTRY_NAME + "/sample.microservice.customization:2.0") `
  --target-port 80 `
  --ingress 'internal' `
  --min-replicas 1 `
  --max-replicas 1 `
  --cpu 0.25 `
  --memory 0.5 `
  --enable-dapr `
  --dapr-app-port 80 `
  --dapr-app-id customization-service

az containerapp create `
--name t1-order `
--resource-group $RESOURCE_GROUP `
--environment $CONTAINERAPPS_ENVIRONMENT `
--image ($REGISTRY_NAME + "/sample.microservice.order:2.0") `
--target-port 80 `
--ingress 'internal' `
--min-replicas 1 `
--max-replicas 1 `
--cpu 0.25 `
--memory 0.5 `
--enable-dapr `
--dapr-app-port 80 `
--dapr-app-id order-service

az containerapp create `
--name t1-proxy `
--resource-group $RESOURCE_GROUP `
--environment $CONTAINERAPPS_ENVIRONMENT `
--image ($REGISTRY_NAME + "/sample.proxy:0.1.6") `
--target-port 80 `
--ingress 'external' `
--min-replicas 1 `
--max-replicas 1 `
--cpu 0.25 `
--memory 0.5 `
--enable-dapr `
--dapr-app-port 80 `
--dapr-app-id proxy-service

# how to get the base url of the proxy service?
$BASE_URL = (az containerapp show --resource-group $RESOURCE_GROUP --name t1-proxy --query "properties.configuration.ingress.fqdn" -o tsv)

# list all container apps in resource group 
az containerapp list `
--resource-group $RESOURCE_GROUP `
--query "[].{Name:name, Provisioned:properties.provisioningState, Image:properties.template.containers[0].image}" `
-o table