//= require deployments/credentials_fields

window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderSelection ||= {}

class SiteFull.Deployments.ProviderSelection

  constructor: ->
    @credentials_fields = new SiteFull.Deployments.CredentialsFields
    @wrapper = '.provider'
    @credentials_wrapper = '.credentials'
    @description = '.description'
    @data_attr = 'data-provider-credentials'
    @data_selector = "[#{@data_attr}]"

  init: ->
    @credentials_fields.init()
    $(document).on 'change', "#{@wrapper} input[type='radio']", (event) =>
      $target = $(event.target)
      @hide_credentials_description() &&
        @hide_all_credentials_sections() &&
        @show_credentials_section_for($target.val()) &&
        @credentials_fields.toggle_fields_visibility()

  hide_credentials_description: ->
    $(@description, @credentials_wrapper).hide()

  hide_all_credentials_sections: ->
    $(@data_selector, @credentials_wrapper).hide().find(':input:not(:disabled)').prop(disabled: true)

  show_credentials_section_for: (section) ->
    $("[#{@data_attr}=#{section}]", @credentials_wrapper).show().find(':input:disabled').prop(disabled: false)
