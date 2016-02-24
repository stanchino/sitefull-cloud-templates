window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderOptions ||= {}
window.SiteFull.Deployments.ProviderOptions.Base ||= {}

class SiteFull.Deployments.ProviderOptions.Base

  constructor: ->
    @flavor_selector = '#deployment_flavor'
    @image_selector = '#deployment_image'
    @instance_wrapper = '.options:visible'
    @region_selector = '#deployment_region'

  add_options_to: (select, options) ->
    select.find('options:not([value=""])').remove()
    $.each options, (i, option) ->
      select.append $('<option/>').val(option.id).text(option.name)

  enable_instance_inputs: ->
    $(':input:visible:disabled', @instance_wrapper).prop(disabled: false)

  disable_instance_inputs: ->
    $(':input:visible:not(:disabled)', @instance_wrapper).prop(disabled: true)
