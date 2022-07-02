# NOTE: Before deploying to any environment, please replace the secrets, settings and resource names
kubectl create secret generic daprgateway-token --from-literal=value="REPLACE"  --type=Opaque
kubectl apply -f daprgateway-dapr.yaml

