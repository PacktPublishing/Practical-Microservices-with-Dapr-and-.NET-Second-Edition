# the following script imports images from Docker Hub into Azure Container Registry to 
# avoid the constraints on downloads from container images repositories  
# see https://learn.microsoft.com/en-us/azure/container-apps/containers for more details
# as the images are imported from Docker Hub, you do not need  to specify credentials
# PLEASE NOTE you need to provide credentials to deploy Azure Container Apps using an Azure Container Registry 
$acr = ""

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.reservationactor:2.0 `
--image sample.microservice.reservationactor:2.0 

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.reservation:2.0 `
--image sample.microservice.reservation:2.0 

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.order:2.0 `
--image sample.microservice.order:2.0 

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.customization:2.0 `
--image sample.microservice.customization:2.0 

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.shipping:2.0 `
--image sample.microservice.shipping:2.0 

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.proxy:0.1.6 `
--image sample.proxy:0.1.6 