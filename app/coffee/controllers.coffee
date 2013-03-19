'use strict'

### Controllers ###

app_name = "myApp"
module = angular.module("#{app_name}.controllers", [])

module.controller 'myCtrl1', ['$scope', ($scope) ->
    $scope.name = "view 1"
    $scope.say = -> window.alert.apply window, arguments
  ]

module.controller 'myCtrl2', ['$scope', ($scope) -> ]