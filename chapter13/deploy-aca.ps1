$CONTAINERAPPS_ENVIRONMENT = ""
$RESOURCE_GROUP = ""
$REGISTRY_NAME = ""
$APPLICATIONINSIGHTS_KEY = ""
$LOG_ANALYTICS_WORKSPACE = ""
$LOCATION = "northeurope"

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

az containerapp create `
  --name t1-reservationactor `
  --resource-group $RESOURCE_GROUP `
  --environment $CONTAINERAPPS_ENVIRONMENT `
  --image $REGISTRY_NAME + "/sample.microservice.reservationactor:2.0" `
  --target-port 80 `
  --ingress 'internal' `
  --min-replicas 1 `
  --max-replicas 1 `
  --enable-dapr `
  --dapr-app-port 80 `
  --dapr-app-id reservationactor-service `
  --dapr-components ./components/reservationactor-components.yaml 

az containerapp create `
  --name t1-reservation `
  --resource-group $RESOURCE_GROUP `
  --environment $CONTAINERAPPS_ENVIRONMENT `
  --image $REGISTRY_NAME + "/sample.microservice.reservation:2.0" `
  --target-port 80 `
  --ingress 'internal' `
  --min-replicas 1 `
  --max-replicas 1 `
  --enable-dapr `
  --dapr-app-port 80 `
  --dapr-app-id reservation-service `
  --dapr-components ./components/reservation-components.yaml 

az containerapp create `
  --name t1-customization `
  --resource-group $RESOURCE_GROUP `
  --environment $CONTAINERAPPS_ENVIRONMENT `
  --image $REGISTRY_NAME + "/sample.microservice.customization:2.0" `
  --target-port 80 `
  --ingress 'internal' `
  --min-replicas 1 `
  --max-replicas 1 `
  --enable-dapr `
  --dapr-app-port 80 `
  --dapr-app-id customization-service `
  --dapr-components ./components/customization-components.yaml 

az containerapp create `
--name t1-order `
--resource-group $RESOURCE_GROUP `
--environment $CONTAINERAPPS_ENVIRONMENT `
--image $REGISTRY_NAME + "dbacawdapracr.azurecr.io/sample.microservice.order:2.0" `
--target-port 80 `
--ingress 'external' `
--min-replicas 1 `
--max-replicas 1 `
--enable-dapr `
--dapr-app-port 80 `
--dapr-app-id order-service `
--dapr-components ./components/order-components.yaml

$ORDER_BASE_URL = (az containerapp show --resource-group $RESOURCE_GROUP --name t1-order --query "latestRevisionFqdn" -o tsv)

az containerapp list `
--resource-group $RESOURCE_GROUP