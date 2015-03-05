require! {
  'gulp'
  'yargs': {argv}
  'require-dir'
}

global.languages = ['en' 'es-419' 'nl']
global.default-lang = 'en'

global.optimized = argv.o or argv.optimized or argv.optimised or false
console.log "Optimized?: #optimized"

global.src = {
  assets: './app/assets/**/*'
  audio: './app/audio/**/*'
  audio-cache: './gulp-cache/audio/**/*'
  css-all: './app/styles/**/*.styl'
  css: ['./app/styles/app.styl', './app/styles/min.styl']
  fonts: './bower_components/font-awesome/fonts/*'
  hbs: './app/scripts/**/*.hbs'
  images: './app/assets/**/*.{jpg,png,gif}'
  locale-data: './locales/**/*.json'
  locale-templates: './app/l10n-templates/**/*'
  lsc: './app/scripts/**/*.ls'
  tests: './test/**/*.ls'
  vendor: ['./vendor/*.js' './vendor/rework/rework.js', './vendor/slowparse/slowparse.js']
  workers-static: ['./bower_components/underscore/underscore.js'
                   './app/workers/**/*.js'
                   './vendor/require.js']
  workers: './app/workers/**/*.ls'
}

global.dest = {
  all: './public/'
  assets: './public'
  audio: './public/audio'
  audio-cache: './gulp-cache/audio'
  cache: './gulp-cache/'
  css: './public/css'
  data: './public/data'
  fonts: './public/fonts'
  images: './app/assets'
  js: './public/js'
  tests: './.test'
  vendor: './public/lib'
}

gulp.task 'default' <[dev]>

require-dir './tasks'
