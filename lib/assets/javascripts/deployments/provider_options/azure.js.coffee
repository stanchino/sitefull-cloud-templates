window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderOptions ||= {}
window.SiteFull.Deployments.ProviderOptions.Azure ||= {}

class SiteFull.Deployments.ProviderOptions.Azure \
extends SiteFull.Deployments.ProviderOptions.Base
  init: ->
    @get_data_for('regions').done( =>
      @enable_instance_input('regions')
      @bind_region_selection()
    ).fail(@disable_instance_inputs)
      .always( -> $('body').removeClass('loading') )

  bind_region_selection: ->
    $(@instance_wrapper).on 'change', '.regions select', (event) =>
      requests = []
      $.each ['images', 'machine-types'], (index, type) =>
        requests.push @get_data_for(type)
      $.when.apply(undefined, requests)
        .done(@enable_instance_inputs)
        .fail(@disable_instance_inputs)
        .always( -> $('body').removeClass('loading') )
