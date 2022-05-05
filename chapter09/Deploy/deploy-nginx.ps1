$namespace = "default"

# Add the ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Use Helm to deploy an NGINX ingress controller
helm install nginx-ingress ingress-nginx/ingress-nginx `
    --namespace $namespace `
    --set controller.replicaCount=2 `
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="dapringress"

# verify
kubectl --namespace $namespace get services -o wide -w nginx-ingress-ingress-nginx-controller

# create ingress 
kubectl apply -f .\Deploy\ingress-nginx.yaml
