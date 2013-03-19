'use strict'

### Controllers ###

app_name = "myApp"
app = angular.module "#{app_name}.controllers", []

app.controller 'myCtrl1', ['$scope', ($scope) ->
    $scope.name = "view 1"
    $scope.say = -> window.alert.apply window, arguments
  ]

app.controller 'myCtrl2', ['$scope', ($scope) -> ]