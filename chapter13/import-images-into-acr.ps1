$username = ""
$password = ""
$acr = ""

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.reservationactor:2.0 `
--image sample.microservice.reservationactor:2.0 `
--username $username `
--password $password

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.reservation:2.0 `
--image sample.microservice.reservation:2.0 `
--username $username `
--password $password

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.order:2.0 `
--image sample.microservice.order:2.0 `
--username $username `
--password $password

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.customization:2.0 `
--image sample.microservice.customization:2.0 `
--username $username `
--password $password

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.microservice.shipping:2.0 `
--image sample.microservice.shipping:2.0 `
--username $username `
--password $password

az acr import `
--name $acr `
--source docker.io/davidebedin/sample.proxy:0.1.6 `
--image sample.proxy:0.1.6 `
--username $username `
--password $password