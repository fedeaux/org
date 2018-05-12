gulp = require 'gulp'

fs = require 'fs'
gulpFn  = require 'gulp-fn'
rimraf = require 'rimraf'

coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
download = require 'gulp-download2'
haml = require 'gulp-haml'
loadJsonFile = require 'load-json-file'
minifyCSS = require 'gulp-minify-css'
sass = require 'gulp-sass'

CONFIG =
  files:
    cs:
      chrome: './src/coffee/chrome/**/*.coffee'
      lib: './src/coffee/lib/**/*.coffee'
    haml: './src/haml/**/*.haml'
    sass: './src/sass/*.sass'

gulp.task 'coffee-chrome', ->
  gulp.src(CONFIG.files.cs.chrome)
    .pipe coffee(bare: false)
    .pipe gulp.dest('./dist/js/chrome/')

gulp.task 'coffee-lib', ->
  gulp.src(CONFIG.files.cs.lib)
    .pipe coffee(bare: true)
    .pipe(concat('lib.js'))
    .pipe gulp.dest './dist/js/'

gulp.task 'haml', ->
  gulp.src(CONFIG.files.haml)
    .pipe haml()
    .pipe gulp.dest('./dist/html')

gulp.task 'sass', ->
  gulp.src(CONFIG.files.sass)
    .pipe sass()
    .pipe minifyCSS()
    .pipe gulp.dest('./dist/css')

gulp.task 'watch', ->
  gulp.watch CONFIG.files.cs.chrome, ['coffee-chrome']
  gulp.watch CONFIG.files.cs.lib, ['coffee-lib']
  gulp.watch CONFIG.files.haml.layouts, ['haml-layouts']
  gulp.watch CONFIG.files.sass, ['sass']

gulp.task 'clean', ->
  rimraf 'release', ->
    rimraf 'dist/*', ->

gulp.task 'release', ->
  rimraf 'release', ->
    env = loadJsonFile.sync 'config/production.json'

    # Clear release dir
    fs.mkdirSync 'release'

    # manifest.json, release/background.js, release/beacon.js, release/*.html
    gulp.src(['./src/chrome/**/*',
              './dist/js/chrome/background.js',
              './dist/js/chrome/beacon.js',
              './dist/html/**/*'])
      .pipe(gulp.dest('./release/'))

    # assets
    gulp.src('./assets/**/*')
      .pipe(gulp.dest('./release/assets'))

    js_api_url = "#{env.base_url}api/v1/bundles/page.js?js_bundle_environment=chrome_extension"
    # js_api_url = "http://localhost:3000/api/v1/bundles/page.js?js_bundle_environment=chrome_extension"

    # release/page.js
    download([{url: js_api_url, file: 'page.js'}])
      .pipe(gulp.dest('release'))

gulp.task 'default', ['coffee-chrome', 'coffee-lib', 'haml', 'sass', 'watch']
