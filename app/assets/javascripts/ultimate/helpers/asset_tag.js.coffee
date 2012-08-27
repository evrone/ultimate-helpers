#= require ./base
#= require ./tag

@Ultimate.Helpers.AssetTag =

  favicon_link_tag: (source = 'favicon.ico', options = {}) ->
    tag 'link', _.extend {},
        rel: 'shortcut icon'
        type: 'image/vnd.microsoft.icon'
        href: @path_to_image(source)
      , options

  image_path: (source) ->
    if source then @compute_public_path(source, 'images') else ''

  path_to_image: (args...) -> @image_path args...  # aliased to avoid conflicts with an image_path named route

  image_tag: (source, options = {}) ->
    src = options['src'] = @path_to_image(source)
    if _.isUndefined(options['alt']) and src and not /^(?:cid|data):/.test(src)
      options['alt'] = @image_alt(src)
    if size = _.outcasts.delete(options, 'size')
      if matches = size.match(/^(\d+)x(\d+)$/)
        options['width']  = matches[1]
        options['height'] = matches[2]
    Ultimate.Helpers.Tag.tag 'img', options

  image_alt: (src) ->
    _.string.capitalize @without_extension(@basename(src)).replace(/-[A-Fa-f0-9]{32}/, '')



  # ===================== AssetPaths =====================

  URI_REGEXP: /^[-a-z]+:\/\/|^(?:cid|data):|^\/\//

  is_uri: (path) ->
    @URI_REGEXP.test(path)

  RELATIVE_URL_ROOT: ''

  compute_public_path: (source, dir, options = {}) ->
    return source  if @is_uri(source)
    source = @rewrite_extension(source, options['ext'])  if options['ext']
    source = @rewrite_asset_path(source, dir)
    source = @rewrite_relative_url_root(source, @RELATIVE_URL_ROOT)
    source

  rewrite_extension: (source, ext) ->
    "#{@without_extension source}.#{ext}"

  without_extension: (source) ->
    source.replace /^(.+)(\.\w+)$/, '$1'

  ASSET_ID: ''
  asset_ids_cache: {}
  # Use the ASSET_ID inscope variable or the random hash as its cache-busting asset id.
  asset_id: (source) ->
    if _.isString @ASSET_ID
      @ASSET_ID
    else
      @asset_ids_cache[source] or (@asset_ids_cache[source] = 10000000 + Math.floor(Math.random() * 90000000))

  # Break out the asset path rewrite in case plugins wish to put the asset id
  # someplace other than the query string.
  rewrite_asset_path: (source, dir) ->
    source = "/#{dir}/#{source}"  unless source[0] is '/'
    if id = @asset_id(source)
      "#{source}?#{id}"
    else
      source

  rewrite_relative_url_root: (source, relative_url_root) ->
    if relative_url_root and not _.startsWith(source, "#{relative_url_root}/")
      "#{relative_url_root}#{source}"
    else
      source

  basename: (source) ->
    source = matches[2]  if matches = source.match(/^(.*\/)?(.+)?$/)
