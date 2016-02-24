window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderSelection ||= {}

class SiteFull.Deployments.ProviderSelection

  data_attr = 'data-provider-settings'
  description = '.description'
  provider_selector = ".provider input[type='radio']:checked"
  provider_settings = null
  settings_wrapper = '.provider-settings'
  wrapper = '.provider'

  # constructor
  constructor: ->
    provider_settings = new SiteFull.Deployments.ProviderSettings

  # public methods
  init: ->
    init_provider_settings()
    bind_provider_change()

  # private methods
  init_provider_settings = ->
    provider = provider_selection()
    provider_settings.init(provider) if provider?

  bind_provider_change = ->
    $(wrapper).on 'change', "input[type='radio']", (event) ->
      $target = $(event.target)
      oauth_url = $target.data?('oauth-url')
      if oauth_url
        window.location.href = oauth_url
      else
        provider = $target.val()
        render_settings(provider)
        provider_settings.init(provider)

  render_settings = (provider) ->
    hide_settings_description() &&
      hide_all_settings_sections() &&
      show_settings_section_for(provider)

  hide_settings_description = ->
    $(description, settings_wrapper).hide()

  hide_all_settings_sections = ->
    $("[#{data_attr}]", settings_wrapper)
      .hide()
      .find(':input:not(:disabled)')
      .prop(disabled: true)

  show_settings_section_for = (section) ->
    $("[#{data_attr}=#{section}]", settings_wrapper)
      .show()
      .find(':input:disabled')
      .prop(disabled: false)

  provider_selection = ->
    $(provider_selector).val()
