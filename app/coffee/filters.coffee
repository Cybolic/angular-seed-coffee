'use strict'

### Filters ###

app_name = "myApp"
app = angular.module "#{app_name}.filters", []

app.filter 'interpolate', [
  'version', (version) ->
    (text) ->
      String(text).replace /\%VERSION\%/mg, version
]
