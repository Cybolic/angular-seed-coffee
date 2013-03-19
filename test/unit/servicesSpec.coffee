'use strict'

### jasmine specs for services go here ###

app_name = "myApp"

describe 'service', ->
  beforeEach module app_name

  describe 'version', ->
    it 'should return current version', inject (version) ->
      expect(
        version
      ).toEqual '0.1'