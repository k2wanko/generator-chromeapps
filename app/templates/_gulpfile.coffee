
gulp   = require 'gulp'
$      = require('gulp-load-plugins')()
_      = require 'underscore'
fs     = require 'fs'
path   = require 'path'
rimraf = require 'rimraf'
named  = require 'vinyl-named'

config =
  src:'./src'
  dist: './dist'
  loaders: ['coffee']

watchs =
  # task : paths
  scripts:  config.loaders.map((ext)-> path.join(config.src, "./**/*.#{ext}"))
  html:     path.join(config.src, './**/*.jade')
  styles:   path.join(config.src, './**/*.styl')
  manifest: path.join(config.src, './manifest.yml')

loadPackageJson = ->
  JSON.parse fs.readFileSync './package.json'
  
gulp.task 'clean', (done)->
  rimraf config.dist, done

gulp.task 'default', ['build'], ->

gulp.task 'build', ['scripts', 'html', 'styles', 'manifest'], ->

gulp.task 'watch', ['build'], ->
  useTplTasks = ['jade', 'manifest']
  for task, paths of watchs
    paths = [paths] if _.isString(paths)
    paths.push './package.json' if useTplTasks.indexOf(task) >= 0
    gulp.watch paths, [task]
  
gulp.task 'scripts', ->
  gulp.src watchs.scripts
  .pipe $.plumber()
  .pipe named()
  .pipe $.webpack
    module:
      loaders: config.loaders.map (ext)->
        test: new RegExp("\.#{ext}$")
        loader: "#{ext}-loader"
  .pipe gulp.dest config.dist

gulp.task 'html', ->
  gulp.src watchs.html
  .pipe $.plumber()
  .pipe $.jade
    locals:
      meta: loadPackageJson()
    pretty: true
  .pipe gulp.dest config.dist

gulp.task 'styles', ->
  gulp.src watchs.styles
  .pipe $.plumber()
  .pipe $.stylus()
  .pipe gulp.dest config.dist

gulp.task 'manifest', ->
  gulp.src watchs.manifest
  .pipe $.plumber()
  .pipe $.template
    meta: loadPackageJson()
  .pipe $.yaml
    space: 2
  .pipe gulp.dest config.dist
