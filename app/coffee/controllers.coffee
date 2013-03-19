'use strict'

### Controllers ###

app_name = "myApp"
self = angular.module("#{app_name}.controllers", [])

self.controller 'myCtrl1', ['$scope', ($scope) ->
    $scope.name = "view 1"
    $scope.say = -> window.alert.apply window, arguments
  ]

self.controller 'myCtrl2', ['$scope', ($scope) -> ]