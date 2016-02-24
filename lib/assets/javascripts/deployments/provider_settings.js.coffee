window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderSettings ||= {}

class SiteFull.Deployments.ProviderSettings

  constructor: ->
    @interval = 250
    @provider_options = null
    @provider_options_factory = new SiteFull.Deployments.ProviderOptions.Factory
    @timer = null
    @wrapper = '.provider-settings'


  init: (provider) ->
    @provider_options = @provider_options_factory.provider_options_for(provider)
    @toggle_fields_visibility()
    @bind_credentials_change()

  # private methods
  bind_credentials_change: ->
    $(@wrapper).on 'change', ':input', (event) =>
      event.stopPropagation()
      clearTimeout(@timer)
      @timer = setTimeout( =>
        @toggle_fields_visibility()
      , @interval)

  toggle_fields_visibility: ->
    if @all_values_set()
      @validate()
    else
      @provider_options.disable_instance_inputs()

  all_values_set: ->
    $(':input:visible', @wrapper).filter( -> return @.value == '').length == 0

  validate: ->
    values = $(':input:visible', @wrapper).serializeArray()
    url = $('[data-validate-url]:visible', @wrapper).data?('validate-url')
    $.ajax
      url: url
      dataType: 'json'
      method: 'post'
      data: $(':input:not(:disabled):not([name="_method"])').serializeArray()
    .done( =>
      @provider_options.init()
    ).fail( (xhr, textStatus, errorThrown) =>
      @provider_options.disable_instance_inputs()
    )
