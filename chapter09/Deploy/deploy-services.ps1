# deploy service of applications ONLY if using classic NGINX --- NOT NEEDED if using NGINX + Dapr
kubectl apply -f .\Deploy\service.sample.microservice.order.yaml
kubectl apply -f .\Deploy\service.sample.microservice.reservation.yaml