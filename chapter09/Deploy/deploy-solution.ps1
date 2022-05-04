# deploy Dapr components
kubectl apply -f .\Deploy\component-pubsub.yaml
kubectl apply -f .\Deploy\component-reservationinput.yaml
kubectl apply -f .\Deploy\component-state-order.yaml
kubectl apply -f .\Deploy\component-state-reservation.yaml
kubectl apply -f .\Deploy\component-state-reservationitem.yaml
kubectl apply -f .\Deploy\component-state-shipping.yaml
kubectl apply -f .\Deploy\component-state-customization.yaml

# deploy Dapr application, using containers kept in container registry
kubectl apply -f .\Deploy\sample.microservice.order.yaml
kubectl apply -f .\Deploy\sample.microservice.reservation.yaml
kubectl apply -f .\Deploy\sample.microservice.reservationactor.yaml
kubectl apply -f .\Deploy\sample.microservice.customization.yaml
kubectl apply -f .\Deploy\sample.microservice.shipping.yaml

# a simple way to test if an application is working
kubectl logs -l app=reservationactor-service -c reservationactor-service --namespace default -f