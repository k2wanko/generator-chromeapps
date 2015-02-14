'use strict';

var path = require('path');
var assert = require('yeoman-generator').assert;
var helpers = require('yeoman-generator').test;
var os = require('os');

describe('chromeapps:app', function () {
  before(function (done) {
    helpers.run(path.join(__dirname, '../app'))
      .inDir(path.join(os.tmpdir(), './temp-test'))
      .withOptions({ 'skip-install': true })
      .withPrompt({
        someOption: true
      })
      .on('end', done);
  });

  it('creates files', function () {
    assert.file([
      'bower.json',
      'package.json',
      'gulpfile.coffee',
      '.editorconfig',
      '.jshintrc'
    ]);
  });

  it('create coffee app files', function () {
    assert.file([
      'background.coffee',
      'index.coffee',
      'index.jade',
      'manifest.yml',
      'style.styl'
    ].map(function(f){ return path.join('src/', f)}));
  });
});
