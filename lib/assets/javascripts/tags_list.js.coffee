window.SiteFull ||= {}
window.SiteFull.TagsList ||= {}

class SiteFull.TagsList
  options:
    allowClear: true,
    tags: true
    theme: 'bootstrap'

  constructor: (selector, options) ->
    @selector = selector
    $.extend @options, options

  render: ->
    $(@selector).select2 @options
