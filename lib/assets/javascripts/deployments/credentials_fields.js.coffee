window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.CredentialsFields ||= {}

class SiteFull.Deployments.CredentialsFields

  constructor: ->
    @wrapper = '.credentials'
    @instance_wrapper = '.instance:visible'
    @region_selector = '#deployment_region'
    @flavor_selector = '#deployment_flavor'
    @timer = null
    @interval = 250

  init: ->
    $(document).on 'keyup keypress change blur', (event) =>
      event.stopPropagation()
      clearTimeout(@timer)
      @timer = setTimeout( =>
        @toggle_fields_visibility()
      , @interval)

  toggle_fields_visibility: () ->
    if @all_values_set()
      @validate_credentials()
    else
      @disable_instance_inputs()

  all_values_set: =>
    $(':input:visible', @wrapper).filter( -> return @.value == '').length == 0

  add_options_to: (select, options) =>
    $.each options, (i, option) ->
      select.append $('<option/>').val(option).text(option)

  enable_instance_inputs: ->
    $(':input:visible:disabled', @instance_wrapper).prop(disabled: false)

  disable_instance_inputs: ->
    $(':input:visible:not(:disabled)', @instance_wrapper).prop(disabled: true)

  validate_credentials: ->
    values = $(':input:visible', @wrapper).serializeArray()
    url = $('[data-options-url]:visible', @wrapper).data?('options-url')
    $.ajax
      url: url
      dataType: 'json'
      method: 'post'
      data: $('form').serializeArray()
      success: (data) =>
        @add_options_to $(@region_selector, @instance_wrapper), data.regions
        @add_options_to $(@flavor_selector, @instance_wrapper), data.flavors
        @enable_instance_inputs()
      error: (xhr, textStatus, errorThrown) =>
        @disable_instance_inputs()
