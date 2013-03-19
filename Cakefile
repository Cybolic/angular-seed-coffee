# Cakefile
# Loosely based on the Cakefile at https://github.com/krismolendyke/InstantJasmineCoffee/blob/master/Cakefile

fs     = require 'fs'
{exec} = require 'child_process'
util   = require 'util'
uglify = require 'uglify-js'

srcDirCoffee = 'app/coffee'
dstDirJS     = 'app/js'

dstFileName   = 'app'
dstFileCoffee = "#{dstDirJS}/#{dstFileName}.coffee"
dstFileJS     = "#{dstDirJS}/#{dstFileName}.js"
dstFileJSMin  = "#{dstDirJS}/#{dstFileName}.min.js"

task 'build', 'Build a single minified JavaScript file from the source CoffeeScript files', ->
  util.log "Building #{dstFileJS}"
  appContents = new Array
  coffeeFiles = fs.readdirSync srcDirCoffee
  coffeeFiles.sort().reverse()
  remaining   = coffeeFiles.length
  util.log "Concatenating #{coffeeFiles.length} files..."

  for file, index in coffeeFiles then do (file, index) ->
    fs.readFile "#{srcDirCoffee}/#{file}", 'utf8', (err, fileContents) ->
      handleError(err) if err

      appContents[index] = fileContents
      util.log "[#{index + 1}] #{file}"
      process() if (--remaining) is 0

  process = ->
    # create output dir
    try
      fs.mkdirSync dstDirJS
    catch err
      # don't care if it fails (probably exists)
    fs.writeFile dstFileCoffee, appContents.join('\n\n'), 'utf8', (err) ->
      handleError(err) if err

      exec "coffee --output #{dstDirJS}/ --compile #{dstFileCoffee}", (err, stdout, stderr) ->
        handleError(err) if err
        message = "Compiled #{dstFileJS}"
        util.log message
        fs.unlink dstFileCoffee, (err) -> handleError(err) if err
        invoke 'uglify'

task 'uglify', 'Minify and obfuscate the build JavaScript', ->
  fs.readFile dstFileJS, 'utf8', (err, fileContents) ->
    minified = uglify.minify fileContents,
      fromString: true
      mangle    : true

    fs.writeFile dstFileJSMin, minified.code
    #fs.unlink dstFileJS, (err) -> handleError(err) if err

    message = "Uglified #{dstFileJSMin}"
    util.log message

handleError = (error) ->
  util.log error
  displayNotification error

displayNotification = (message = '') ->
  util.log message