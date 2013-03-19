'use strict'

### Filters ###

app_name = "myApp"
self = angular.module("#{app_name}.filters", [])

self.filter 'interpolate', [
  'version', (version) ->
    (text) ->
      String(text).replace /\%VERSION\%/mg, version
]
