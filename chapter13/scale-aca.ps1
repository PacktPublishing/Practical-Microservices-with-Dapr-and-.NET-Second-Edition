# replace value before starting
$CONTAINERAPPS_ENVIRONMENT = ""
$RESOURCE_GROUP = ""
$REGISTRY_NAME = ""
$APPLICATIONINSIGHTS_NAME = ""
$LOG_ANALYTICS_WORKSPACE = ""
$LOCATION = ""
$COMPONENT_PATH = ""

# to show the existing revisions of a container app
az containerapp revision list `
--name t1-proxy `
--resource-group $RESOURCE_GROUP

#this should be the connection string to the commonpusub Azure Service Bus topic used by all apps
$SB_CONNECTION_STRING = ""

#create secrets in each container app
az containerapp secret set `
--name t1-reservation `
--resource-group $RESOURCE_GROUP `
--secrets pubsub-secret=$SB_CONNECTION_STRING

az containerapp secret set `
--name t1-customization `
--resource-group $RESOURCE_GROUP `
--secrets pubsub-secret=$SB_CONNECTION_STRING

# to create a new revision, deriving from the lastest, with some additional changes
az containerapp revision copy `
--name t1-proxy `
--resource-group $RESOURCE_GROUP `
--yaml .\scale\scale-proxy.yaml

az containerapp revision copy `
--name t1-reservation `
--resource-group $RESOURCE_GROUP `
--yaml .\scale\scale-reservationservice.yaml

az containerapp revision copy `
--name t1-reservationactor `
--resource-group $RESOURCE_GROUP `
--yaml .\scale\scale-reservationactorservice.yaml

az containerapp revision copy `
--name t1-order `
--resource-group $RESOURCE_GROUP `
--yaml .\scale\scale-orderservice.yaml

az containerapp revision copy `
--name t1-customization `
--resource-group $RESOURCE_GROUP `
--yaml .\scale\scale-customizationservice.yaml

