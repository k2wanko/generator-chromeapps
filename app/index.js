'use strict';
var yeoman = require('yeoman-generator');
var chalk = require('chalk');
var yosay = require('yosay');

module.exports = yeoman.generators.Base.extend({
  initializing: function () {
    this.pkg = require('../package.json');
  },

  prompting: function () {
    var done = this.async();

    // Have Yeoman greet the user.
    this.log(yosay(
      'Welcome to the world-class' + chalk.red('Chromeapps') + ' generator!'
    ));

    var prompts = [];

    this.prompt(prompts, function (props) {
      done();
    }.bind(this));
  },

  writing: {
    app: function () {

      [
        ['_package.json', 'package.json'],
        ['_bower.json', 'bower.json']
      ].forEach(function(t){
        this.fs.copy(
          this.templatePath(t[0]),
          this.destinationPath(t[1])
        );
      }.bind(this));

    },

    projectfiles: function () {

      [
        ['editorconfig', '.editorconfig'],
        ['jshintrc', '.jshintrc']
      ].forEach(function(t){
        this.fs.copy(
          this.templatePath(t[0]),
          this.destinationPath(t[1])
        );
      }.bind(this));

    }
  },

  install: function () {
    this.installDependencies({
      skipInstall: this.options['skip-install']
    });
  }
});
