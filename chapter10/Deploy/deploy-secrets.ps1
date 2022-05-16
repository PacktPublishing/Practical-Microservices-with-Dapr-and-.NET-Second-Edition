$namespace = "default"

$cosmosdbsecretmasterkey = ""
$cosmosdbsecreturl = ""
$servicebussecretconnectionstring = ""
$reservationinputsecretconnectionstring = ""
$reservationinputsecretstorageaccountkey = ""

# delete and then create the secrets for the Dapr components
kubectl delete secret cosmosdb-secret --namespace $namespace
kubectl create secret generic cosmosdb-secret --from-literal=masterKey=$cosmosdbsecretmasterkey --from-literal=url=$cosmosdbsecreturl --namespace $namespace
kubectl delete secret servicebus-secret --namespace $namespace
kubectl create secret generic servicebus-secret --from-literal=connectionString=$servicebussecretconnectionstring --namespace $namespace
kubectl delete secret reservationinput-secret --namespace $namespace
kubectl create secret generic reservationinput-secret --from-literal=connectionString=$reservationinputsecretconnectionString --from-literal=storageAccountKey=$reservationinputsecretstorageaccountkey --namespace $namespace
