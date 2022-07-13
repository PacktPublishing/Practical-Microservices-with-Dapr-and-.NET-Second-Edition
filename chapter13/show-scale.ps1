$CONTAINERAPPS_ENVIRONMENT = ""
$RESOURCE_GROUP = ""
$CONTAINERAPP_REVISION = ""
$CONTAINERAPP_NAME = "t1-reservation"

az containerapp revision list `
    --name $CONTAINERAPP_NAME `
    --resource-group $RESOURCE_GROUP `
    --query '[].{Revision:name}' `
    --output table

$CONTAINERAPP_REVISION = (az containerapp revision list --name $CONTAINERAPP_NAME --resource-group $RESOURCE_GROUP --query '[?properties.active] [].name' --output tsv)

az containerapp revision show `
    --revision $CONTAINERAPP_REVISION `
    --resource-group $RESOURCE_GROUP `
    --query '{Replicas:properties.replicas, Max:properties.template.scale.maxReplicas, Min:properties.template.scale.minReplicas}' `
    --output table