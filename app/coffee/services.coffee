'use strict'

### Services ###

app_name = "myApp"
self = angular.module("#{app_name}.services", [])


# Demonstrate how to register services
# In this case it is a simple value service.
self.value 'version', '0.1'
