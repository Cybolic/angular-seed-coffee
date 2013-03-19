'use strict'

### Controllers ###


window.controllers =
  'myCtrl1': ['$scope', ($scope) ->
    $scope.name = "view 1"
  ]
  'myCtrl2': ['$scope', ($scope) -> ]
  'init': (module) ->
    for controller, definition of controllers
      module.controller controller, definition
