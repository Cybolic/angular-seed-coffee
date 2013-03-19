'use strict'

### jasmine specs for filters go here ###

app_name = "myApp"

describe 'filter', ->
  beforeEach module app_name

  describe 'interpolate', ->
    beforeEach module ($provide) ->
      $provide.value 'version', 'TEST_VER'
      null

    it 'should replace VERSION', inject (interpolateFilter) ->
      expect(
        interpolateFilter 'before %VERSION% after'
      ).toEqual 'before TEST_VER after'