window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderOptions ||= {}

class SiteFull.Deployments.ProviderOptions

  flavor_selector = '#deployment_flavor'
  image_selector = '#deployment_image'
  instance_wrapper = '.options:visible'
  region_selector = '#deployment_region'

  set_strategy: (provider) ->
    @strategy = get_strategy(provider)

  enable:
    @strategy.enable()

  disable:
    disable_instance_inputs()

  get_strategy = (provider) ->
    if provider == 'aws'
      new SiteFull.Deployments.AwsOptions
    else if provider == 'google'
      new SiteFull.Deployments.GoogleOptions

  enable_orig: ->
    add_options_to $(region_selector, instance_wrapper), data.regions
    add_options_to $(image_selector, instance_wrapper), data.images
    add_options_to $(flavor_selector, instance_wrapper), data.flavors
    enable_instance_inputs()

  add_options_to = (select, options) ->
    select.find('options:not([value=""])').remove()
    $.each options, (i, option) ->
      select.append $('<option/>').val(option.id).text(option.name)

  enable_instance_inputs = ->
    $(':input:visible:disabled', instance_wrapper).prop(disabled: false)

  disable_instance_inputs = ->
    $(':input:visible:not(:disabled)', instance_wrapper).prop(disabled: true)
