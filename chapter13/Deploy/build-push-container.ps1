# meant to be launched from the solution root folder
# with this file you can build all the project docker images with version and default$default
# in addition it pushes the images to the container registry
param (
    [string]$registry = "registry", 
    [string]$default = "latest"
    )
$builddate = "2022-09-01"
$buildversion = "0.1.6"

$container = "sample.proxy"
$latest = "{0}/{1}:{2}" -f $registry, $container, $default 
$versioned = "{0}/{1}:{2}" -f $registry, $container, $buildversion
docker build . -f .\sample.proxy\Dockerfile -t $latest -t $versioned --build-arg BUILD_DATE=$builddate --build-arg BUILD_VERSION=$buildversion
docker push $versioned
docker push $latest 
