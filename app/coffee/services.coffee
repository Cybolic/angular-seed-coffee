'use strict'

### Services ###

app_name = "myApp"
module = angular.module("#{app_name}.services", [])


# Demonstrate how to register services
# In this case it is a simple value service.
module.value 'version', '0.1'
