window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderOptions ||= {}
window.SiteFull.Deployments.ProviderOptions.Google ||= {}

class SiteFull.Deployments.ProviderOptions.Google \
extends SiteFull.Deployments.ProviderOptions.Base
  init: ->
    requests = []
    $.each ['regions', 'images'], (index, type) =>
      requests.push @get_data_for(type)
    $.when.apply(undefined, requests).done( =>
      @enable_instance_input('regions')
      @enable_instance_input('images')
      @bind_region_selection()
    ).fail(@disable_instance_inputs)
      .always( -> $('body').removeClass('loading') )

  bind_region_selection: ->
    $(@instance_wrapper).on 'change', '.regions select', (event) =>
      @get_data_for('flavors').done( =>
        @enable_instance_input('flavors')
      ).fail(@disable_instance_inputs)
        .always( -> $('body').removeClass('loading') )
