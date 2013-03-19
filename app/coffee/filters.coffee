'use strict'

### Filters ###

app_name = "myApp"
module = angular.module("#{app_name}.filters", [])

module.filter 'interpolate', [
  'version', (version) ->
    (text) ->
      String(text).replace /\%VERSION\%/mg, version
]
