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

# to create a new revision, deriving from the lastest, with some additional changes
az containerapp revision copy `
--name t1-proxy `
--resource-group $RESOURCE_GROUP `
--yaml .\scale\scale-proxy.yaml

az containerapp revision copy `
--name t1-reservation `
--resource-group $RESOURCE_GROUP `
--yaml .\scale\scale-reservationservice.yaml