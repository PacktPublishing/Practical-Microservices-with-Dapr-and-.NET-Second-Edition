# meant to be launched from the solution root folder
# with this file you can build all the project docker images with version and defatag
param (
    [string]$registry = "registry", 
    [string]$default = "latest"
    )
$builddate = "2022-09-15"
$buildversion = "2.0"

$container = "sample.microservice.order"
$latest = "{0}/{1}:{2}" -f $registry, $container, $default 
$versioned = "{0}/{1}:{2}" -f $registry, $container, $buildversion
docker build . -f .\sample.microservice.order\Dockerfile -t $latest -t $versioned --build-arg BUILD_DATE=$builddate --build-arg BUILD_VERSION=$buildversion

$container = "sample.microservice.reservationactor"
$latest = "{0}/{1}:{2}" -f $registry, $container, $default 
$versioned = "{0}/{1}:{2}" -f $registry, $container, $buildversion
docker build . -f .\sample.microservice.reservationactor.service\Dockerfile -t $latest -t $versioned --build-arg BUILD_DATE=$builddate --build-arg BUILD_VERSION=$buildversion

$container = "sample.microservice.reservation"
$latest = "{0}/{1}:{2}" -f $registry, $container, $default 
$versioned = "{0}/{1}:{2}" -f $registry, $container, $buildversion
docker build . -f .\sample.microservice.reservation\Dockerfile -t $latest -t $versioned --build-arg BUILD_DATE=$builddate --build-arg BUILD_VERSION=$buildversion

$container = "sample.microservice.customization"
$latest = "{0}/{1}:{2}" -f $registry, $container, $default 
$versioned = "{0}/{1}:{2}" -f $registry, $container, $buildversion
docker build . -f .\sample.microservice.customization\Dockerfile -t $latest -t $versioned --build-arg BUILD_DATE=$builddate --build-arg BUILD_VERSION=$buildversion

$container = "sample.microservice.shipping"
$latest = "{0}/{1}:{2}" -f $registry, $container, $default
$versioned = "{0}/{1}:{2}" -f $registry, $container, $buildversion
docker build . -f .\sample.microservice.shipping\Dockerfile -t $latest -t $versioned --build-arg BUILD_DATE=$builddate --build-arg BUILD_VERSION=$buildversion
