$CONTAINERAPPS_ENVIRONMENT = ""
$RESOURCE_GROUP = ""
$CONTAINERAPP_REVISION = ""
$CONTAINERAPP_NAME = "t1-reservationactor"

az containerapp revision list `
    --name $CONTAINERAPP_NAME `
    --resource-group $RESOURCE_GROUP `
    --query '[].{Revision:name}' `
    --output table

$CONTAINERAPP_REVISION = (az containerapp revision list --name $CONTAINERAPP_NAME --resource-group $RESOURCE_GROUP --query '[].name' --output tsv)

az containerapp revision show `
    --name $CONTAINERAPP_REVISION `
    --app $CONTAINERAPP_NAME `
    --resource-group $RESOURCE_GROUP `
    --query '{Replicas:replicas, Max:template.scale.maxReplicas, Min:template.scale.minReplicas}' `
    --output table