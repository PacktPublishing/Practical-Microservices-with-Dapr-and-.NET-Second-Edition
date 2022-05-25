kubectl create secret generic daprgateway-token --from-literal=value="REPLACE"  --type=Opaque
kubectl apply -f daprgateway-dapr.yaml