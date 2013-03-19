basePath = '../';

files = [
  JASMINE,
  JASMINE_ADAPTER,
  'app/lib/angular/angular.js',
  'app/lib/angular/angular-*.js',
  'test/lib/angular/angular-mocks.js',
  'test/**/*Spec.coffee',
  'app/coffee/services.coffee',
  'app/coffee/controllers.coffee',
  'app/coffee/filters.coffee',
  'app/coffee/directives.coffee',
  'app/coffee/app.coffee',
];

autoWatch = true;

browsers = ['Chrome'];

junitReporter = {
  outputFile: 'test_out/unit.xml',
  suite: 'unit'
};
