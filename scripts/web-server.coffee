#!/usr/bin/env coffee

util   = require 'util'
http   = require 'http'
fs     = require 'fs'
url    = require 'url'
events = require 'events'

DEFAULT_PORT = 8000

main = (argv) ->
  new HttpServer
    'GET': createServlet StaticServlet
    'HEAD': createServlet StaticServlet
  .start Number(argv[2]) || DEFAULT_PORT

escapeHtml = (value) ->
  value.toString()
    .replace('<', '&lt;')
    .replace('>', '&gt;')
    .replace('"', '&quot;')

createServlet = (Class) ->
  servlet = new Class()
  servlet.handleRequest.bind servlet

###
 # An Http server implementation that uses a map of methods to decide
 # action routing.
 #
 # @param {Object} Map of method => Handler function
###
class HttpServer
  constructor: (@handlers) ->
    @server = http.createServer @handleRequest_.bind @

  start: (@port) =>
    @server.listen port
    util.puts "Http Server running at http://localhost:#{port}/"

  parseUrl_: (urlString) ->
    parsed = url.parse urlString
    parsed.pathname = url.resolve '/', parsed.pathname
    url.parse (url.format parsed), true

  handleRequest_: (req, res) =>
    logEntry = req.method + ' ' + req.url
    logEntry += ' ' + req.headers['user-agent']  if req.headers['user-agent']
    util.puts logEntry
    req.url = @parseUrl_ req.url
    handler = @handlers[req.method]
    unless handler
      res.writeHead 501
      res.end()
    else
      handler.call this, req, res

###
 # Handles static content.
###
StaticServlet = ->

StaticServlet.MimeMap =
  'txt': 'text/plain'
  'html': 'text/html'
  'css': 'text/css'
  'xml': 'application/xml'
  'json': 'application/json'
  'js': 'application/javascript'
  'jpg': 'image/jpeg'
  'jpeg': 'image/jpeg'
  'gif': 'image/gif'
  'png': 'image/png'
  'svg': 'image/svg+xml'

StaticServlet.prototype.handleRequest = (req, res) ->
  path = ('./' + req.url.pathname).replace('//','/').replace /%(..)/g, (match, hex) ->
    String.fromCharCode parseInt hex, 16

  parts = path.split '/'
  if parts[parts.length-1].charAt(0) is '.'
    @sendForbidden_ req, res, path
  fs.stat path, (err, stat) =>
    if err
      return @sendMissing_ req, res, path
    if stat.isDirectory()
      return @sendDirectory_ req, res, path
    return @sendFile_ req, res, path

StaticServlet.prototype.sendError_ = (req, res, error) ->
  res.writeHead 500,
    'Content-Type': 'text/html'
  res.write """<!doctype html>\n
    <title>Internal Server Error</title>\n
    <h1>Internal Server Error</h1>
    <pre>#{ escapeHtml util.inspect error }</pre>"""
  util.puts '500 Internal Server Error'
  util.puts util.inspect error

StaticServlet.prototype.sendMissing_ = (req, res, path) ->
  path = path.substring 1
  res.writeHead 404,
    'Content-Type': 'text/html'
  res.write """<!doctype html>\n
    <title>404 Not Found</title>\n
    <h1>Not Found</h1>
    <p>The requested URL #{ escapeHtml path } was not found on this server.</p>"""
  res.end()
  util.puts "404 Not Found: #{path}"

StaticServlet.prototype.sendForbidden_ = (req, res, path) ->
  path = path.substring 1
  res.writeHead 403,
    'Content-Type': 'text/html'
  res.write """<!doctype html>\n
    <title>403 Forbidden</title>\n
    <h1>Forbidden</h1>
    <p>You do not have permission to access #{ escapeHtml path } on this server.</p>"""
  res.end()
  util.puts "403 Forbidden: #{path}"

StaticServlet.prototype.sendRedirect_ = (req, res, redirectUrl) ->
  res.writeHead 301,
    'Content-Type': 'text/html'
    'Location': redirectUrl
  res.write """<!doctype html>\n'
    <title>301 Moved Permanently</title>\n
    <h1>Moved Permanently</h1>

    <p>The document has moved <a href="#{ redirectUrl }">here</a>.</p>"""
  res.end()
  util.puts "301 Moved Permanently: #{redirectUrl}"

StaticServlet.prototype.sendFile_ = (req, res, path) ->
  file = fs.createReadStream path
  res.writeHead 200,
    'Content-Type': StaticServlet.MimeMap[ path.split('.').pop() ] || 'text/plain'

  if req.method is 'HEAD'
    res.end()
  else
    file.on 'data', res.write.bind res
    file.on 'close', () -> res.end()
    file.on 'error', (error) => @sendError_ req, res, error

StaticServlet.prototype.sendDirectory_ = (req, res, path) ->
  if path.match /[^\/]$/
    req.url.pathname += '/'
    redirectUrl = url.format url.parse url.format req.url
    return @sendRedirect_ req, res, redirectUrl

  fs.readdir path, (err, files) =>
    return @sendError_ req, res, error  if err
    return @writeDirectoryIndex_ req, res, path, []  unless files.length

    remaining = files.length
    files.forEach (fileName, index) =>
      fs.stat "#{path}/#{fileName}", (err, stat) =>
        return @sendError_ req, res, err  if err

        if stat.isDirectory()
          files[index] = fileName + '/'

        unless (--remaining)
          return @writeDirectoryIndex_ req, res, path, files

StaticServlet.prototype.writeDirectoryIndex_ = (req, res, path, files) ->
  path = path.substring 1
  res.writeHead 200,
    'Content-Type': 'text/html'

  if req.method is 'HEAD'
    res.end()
    return

  res.write """<!doctype html>\n
    <title>#{ escapeHtml path }</title>\n
    <style>\n
      ol { list-style-type: none; font-size: 1.2em; }\n
    </style>\n
    <h1>Directory: #{ escapeHtml path }</h1>
    <ol>"""
  files.forEach (fileName) ->
    unless fileName.charAt(0) is '.'
      res.write """<li><a href="
        #{ escapeHtml fileName }">
        #{ escapeHtml fileName }</a></li>"""
  res.write '</ol>'
  res.end()

# Must be last,
main process.argv
