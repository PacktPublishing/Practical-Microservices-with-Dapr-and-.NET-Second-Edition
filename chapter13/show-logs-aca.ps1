$CONTAINERAPPS_ENVIRONMENT = ""
$RESOURCE_GROUP = ""
$LOG_ANALYTICS_WORKSPACE=""
$CONTAINERAPP_NAME = "t1-reservationactor"

$LOG_ANALYTICS_WORKSPACE_CLIENT_ID=(az monitor log-analytics workspace show --query customerId -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv)

az monitor log-analytics query `
  --workspace $LOG_ANALYTICS_WORKSPACE_CLIENT_ID `
  --analytics-query "ContainerAppConsoleLogs_CL | where ContainerAppName_s == '$CONTAINERAPP_NAME' | project ContainerAppName_s, Log_s, TimeGenerated | take 30" `
  --out table