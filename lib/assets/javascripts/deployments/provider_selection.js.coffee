window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderSelection ||= {}

class SiteFull.Deployments.ProviderSelection

  constructor: ->
    @data_attr = 'data-provider-settings'
    @description = '.description'
    @provider_selector = ".provider input[type='radio']:checked"
    @provider_settings = new SiteFull.Deployments.ProviderSettings
    @settings_wrapper = '.provider-settings'
    @wrapper = '.provider'


  init: ->
    @init_provider_settings()
    @bind_provider_change()

  init_provider_settings: ->
    provider = @provider_selection()
    @provider_settings.init(provider) if provider?

  bind_provider_change: ->
    $(@wrapper).on 'change', "input[type='radio']", (event) =>
      $target = $(event.target)
      auth_url = $target.data?('auth-url')
      if auth_url
        window.location.href = auth_url

  hide_settings_description: ->
    $(@description, @settings_wrapper).hide()

  hide_all_settings_sections: ->
    sections = $("[#{@data_attr}]", @settings_wrapper)
    sections.find(':input:visible:not(:disabled)').val('').prop(disabled: true)
    sections.hide()

  show_settings_section_for: (section) ->
    $("[#{@data_attr}=#{section}]", @settings_wrapper)
      .show()
      .find(':input:visible:disabled')
      .prop(disabled: false)

  provider_selection: ->
    $(@provider_selector).data?('provider-textkey')
