'use strict'

# Declare app level module which depends on filters, and services
controllers.init angular.module('myApp', ['myApp.filters', 'myApp.services', 'myApp.directives'])
  .config ['$routeProvider', ($routeProvider) =>

    $routeProvider.when '/view1',
      templateUrl: 'partials/partial1.html'
      controller: 'myCtrl1'

    $routeProvider.when '/view2',
      templateUrl: 'partials/partial2.html'
      controller: 'myCtrl2'

    $routeProvider.otherwise
      redirectTo: '/view1'
  ]

angular.bootstrap document, ["myApp"]