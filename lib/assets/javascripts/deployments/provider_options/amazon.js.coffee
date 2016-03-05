window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderOptions ||= {}
window.SiteFull.Deployments.ProviderOptions.Amazon ||= {}

class SiteFull.Deployments.ProviderOptions.Amazon \
extends SiteFull.Deployments.ProviderOptions.Base
  init: ->
    requests = []
    $.each ['regions', 'images', 'machine_types'], (index, type) =>
      requests.push @get_data_for(type)
    $.when.apply(undefined, requests)
      .done(@enable_instance_inputs)
      .fail(@disable_instance_inputs)
      .always( -> $('body').removeClass('loading') )

