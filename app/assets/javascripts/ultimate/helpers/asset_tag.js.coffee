
@is_uri = (path) ->
  /^[-a-z]+:\/\/|^cid:|^\/\//.test path

@without_extension = (source) ->
  source.replace /^(.+)(\.\w+)$/, '$1'

@rewrite_extension = (source, ext) =>
  "#{@without_extension source}.#{ext}"

@ASSET_ID = ''
@asset_ids_cache = {}
# Use the ASSET_ID inscope variable or the random hash as its cache-busting asset id.
@asset_id = (source) =>
  if _.isString @ASSET_ID
    @ASSET_ID
  else
    @asset_ids_cache[source] or (@asset_ids_cache[source] = 10000000 + Math.floor(Math.random() * 90000000))

# Break out the asset path rewrite in case plugins wish to put the asset id
# someplace other than the query string.
@rewrite_asset_path = (source, dir) =>
  source = "/#{dir}/#{source}"  unless source[0] is '/'
  if id = @asset_id(source)
    "#{source}?#{id}"
  else
    source

@rewrite_relative_url_root = (source, relative_url_root) ->
  if relative_url_root and not _.startsWith(source, "#{relative_url_root}/")
    "#{relative_url_root}#{source}"
  else
    source

@RELATIVE_URL_ROOT = ''

@compute_public_path = (source, dir, options = {}) =>
  return source  if is_uri(source)
  source = @rewrite_extension(source, options['ext'])  if options['ext']
  source = @rewrite_asset_path(source, dir)
  source = @rewrite_relative_url_root(source, @RELATIVE_URL_ROOT)
  source

@image_path = (source) =>
  @compute_public_path(source, 'images')

@path_to_image = @image_path  # aliased to avoid conflicts with an image_path named route

@basename = (source) =>
  source = matches[2]  if matches = source.match /^(.*\/)?(.+)?$/

@image_alt = (src) =>
  _.capitalize @without_extension(@basename(src))

@image_tag = (source, options = {}) =>
  src = options['src'] = @path_to_image source
  unless options['alt'] or /^cid:/.test src
    options['alt'] = @image_alt(src)
  if size = _delete(options, 'size')
    if matches = size.match /^(\d+)x(\d+)$/
      options['width']  = matches[1]
      options['height'] = matches[2]
  tag 'img', options
