$CONTAINERAPPS_ENVIRONMENT = ""
$RESOURCE_GROUP = ""
$REGISTRY_NAME = ""
$APPLICATIONINSIGHTS_KEY = ""
$LOG_ANALYTICS_WORKSPACE = ""
$LOCATION = "northeurope"
$COMPONENT_PATH = ""

$LOG_ANALYTICS_WORKSPACE_CLIENT_ID=(az monitor log-analytics workspace show --query customerId -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv)
$LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=(az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE -o tsv)

az containerapp env create `
--name $CONTAINERAPPS_ENVIRONMENT `
--resource-group $RESOURCE_GROUP `
--dapr-instrumentation-key $APPLICATIONINSIGHTS_KEY `
--logs-workspace-id $LOG_ANALYTICS_WORKSPACE_CLIENT_ID `
--logs-workspace-key $LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET `
--location $LOCATION 
  
  # `
  # --secrets pubsub-servicebus-connectionstring="${PUBSUB_CONNECTIONSTRING}" `
  #   reservationactorstore-cosmosdb-url="${DB_URL}" `
  #   reservationactorstore-cosmosdb-masterkey="${DB_MASTERKEY}" `
  #   reservationstore-cosmosdb-url="${DB_URL}" `
  #   reservationstore-cosmosdb-masterkey="${DB_MASTERKEY}" `
  #   customizationstore-cosmosdb-url="${DB_URL}" `
  #   customizationstore-cosmosdb-masterkey="${DB_MASTERKEY}" `
  #   orderstore-cosmosdb-url="${DB_URL}" `
  #   orderstore-cosmosdb-masterkey="${DB_MASTERKEY}"

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
--enable-dapr `
--dapr-app-port 80 `
--dapr-app-id order-service

az containerapp create `
--name t1-proxy `
--resource-group $RESOURCE_GROUP `
--environment $CONTAINERAPPS_ENVIRONMENT `
--image ($REGISTRY_NAME + "/sample.proxy:0.1") `
--target-port 80 `
--ingress 'external' `
--min-replicas 1 `
--max-replicas 1 `
--enable-dapr `
--dapr-app-port 80 `
--dapr-app-id proxy-service

$ORDER_BASE_URL = (az containerapp show --resource-group $RESOURCE_GROUP --name t1-order --query "latestRevisionFqdn" -o tsv)

az containerapp list `
--resource-group $RESOURCE_GROUP