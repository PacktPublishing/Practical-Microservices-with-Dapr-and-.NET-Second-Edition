$namespace = "default"

# deploy Dapr components
kubectl apply -f .\Deploy\component-pubsub.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-reservationinput.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-state-order.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-state-reservation.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-state-reservationitem.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-state-shipping.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-state-customization.yaml --namespace $namespace

# ATTENTION !!!!
# replace placeholder <registry> with the correct name of your container registry
# in all  yaml files, such as .\Deploy\sample.microservice.order.yaml, 
# image: <registry>/sample.microservice.order:2.0

# deploy Dapr application, using containers kept in container registry
kubectl apply -f .\Deploy\sample.microservice.order.yaml --namespace $namespace
kubectl apply -f .\Deploy\sample.microservice.reservation.yaml --namespace $namespace
kubectl apply -f .\Deploy\sample.microservice.reservationactor.yaml --namespace $namespace
kubectl apply -f .\Deploy\sample.microservice.customization.yaml --namespace $namespace
kubectl apply -f .\Deploy\sample.microservice.shipping.yaml --namespace $namespace

# a simple way to test if an application is working
kubectl logs -l app=reservationactor-service -c reservationactor-service --namespace $namespace -f