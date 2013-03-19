'use strict'

### jasmine specs for controllers go here ###

app_name = "myApp"

describe 'Controllers', ->
  beforeEach module app_name

  describe 'myCtrl1', ->
    scope = {}; ctrl = null
    beforeEach inject ($controller) ->
      ctrl = $controller 'myCtrl1', {$scope: scope}

    it 'should have a name variable and a say function defined', ->
      expect(
        scope.name
      ).toMatch /view 1/

      expect(
        scope.say
      ).toBeDefined()


  describe 'myCtrl2', ->
    myCtrl2 = null

    scope = {}; ctrl = null
    beforeEach inject ($controller) ->
      ctrl = $controller 'myCtrl2', {$scope: scope}

    it 'should ....', ->
      #spec body