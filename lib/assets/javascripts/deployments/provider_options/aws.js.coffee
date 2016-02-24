window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderOptions ||= {}
window.SiteFull.Deployments.ProviderOptions.Aws ||= {}

class SiteFull.Deployments.ProviderOptions.Aws extends SiteFull.Deployments.ProviderOptions.Base
  init: (data) ->
    @add_options_to $(@region_selector, @instance_wrapper), data.regions
    @add_options_to $(@image_selector,  @instance_wrapper), data.images
    @add_options_to $(@flavor_selector, @instance_wrapper), data.flavors
    @enable_instance_inputs()
