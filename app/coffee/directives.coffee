'use strict'

### Directives ###

app_name = "myApp"
self = angular.module("#{app_name}.directives", [])

self.directive 'appVersion', [
  'version', (version) ->
    (scope, element, attrs) ->
      element.text version
]

# From https://gist.github.com/geelen/2873603
window.stoppingPropagation = (callback) -> (event) ->
  event.stopPropagation()
  callback(event)

self.directive 'ngTap', ->
  (scope, element, attrs) ->
    tapping = false
    element.bind 'touchstart', stoppingPropagation (event) -> tapping = true
    element.bind 'touchmove' , stoppingPropagation (event) -> tapping = false
    element.bind 'touchend'  , stoppingPropagation (event) -> scope.$apply(attrs['ngTap']) if tapping