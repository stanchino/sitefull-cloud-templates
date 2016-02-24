window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderSettings ||= {}

class SiteFull.Deployments.ProviderSettings

  interval = 250
  provider_options = null
  provider_options_factory = null
  timer = null
  wrapper = '.provider-settings'

  constructor: ->
    provider_options_factory = new SiteFull.Deployments.ProviderOptions.Factory

  init: (provider) ->
    provider_options = provider_options_factory.provider_options_for(provider)
    toggle_fields_visibility()
    bind_credentials_change()

  # private methods
  bind_credentials_change = ->
    $(wrapper).on 'keyup keypress change blur', ':input', (event) =>
      event.stopPropagation()
      clearTimeout(timer)
      timer = setTimeout( =>
        toggle_fields_visibility()
      , interval)

  toggle_fields_visibility = ->
    if all_values_set()
      validate_credentials()
    else
      provider_options.disable_instance_inputs()

  all_values_set = ->
    $(':input:visible', wrapper).filter( -> return @.value == '').length == 0

  validate_credentials = ->
    values = $(':input:visible', wrapper).serializeArray()
    url = $('[data-options-url]:visible', wrapper).data?('options-url')
    $.ajax
      url: url
      dataType: 'json'
      method: 'post'
      data: $(':input:not(:disabled):not([name="_method"])').serializeArray()
      success: (data) ->
        provider_options.init(regions: [], images: [], flavors: [])
      error: (xhr, textStatus, errorThrown) ->
        provider_options.disable_instance_inputs()
