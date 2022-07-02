$username = ""
$password = ""
$acr = ""

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.reservationactor:latest `
--image sample.microservice.reservationactor:latest `
--username $username `
--password $password

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.reservation:latest `
--image sample.microservice.reservation:latest `
--username $username `
--password $password

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.order:latest `
--image sample.microservice.order:latest `
--username $username `
--password $password

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.customization:latest `
--image sample.microservice.customization:latest `
--username $username `
--password $password

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.shipping:latest `
--image sample.microservice.shipping:latest `
--username $username `
--password $password