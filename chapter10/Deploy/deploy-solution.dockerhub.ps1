$namespace = "default"

# deploy Dapr components
kubectl apply -f .\Deploy\component-pubsub.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-reservationinput.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-state-order.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-state-reservation.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-state-reservationitem.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-state-shipping.yaml --namespace $namespace
kubectl apply -f .\Deploy\component-state-customization.yaml --namespace $namespace

# deploy Dapr application, using containers images from DockerHub
kubectl apply -f .\Deploy\sample.microservice.order.dockerhub.yaml --namespace $namespace
kubectl apply -f .\Deploy\sample.microservice.reservation.dockerhub.yaml --namespace $namespace
kubectl apply -f .\Deploy\sample.microservice.reservationactor.dockerhub.yaml --namespace $namespace
kubectl apply -f .\Deploy\sample.microservice.customization.dockerhub.yaml --namespace $namespace
kubectl apply -f .\Deploy\sample.microservice.shipping.dockerhub.yaml --namespace $namespace

# a simple way to test if an application is working
kubectl logs -l app=reservationactor-service -c reservationactor-service --namespace $namespace -f