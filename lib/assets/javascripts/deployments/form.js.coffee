window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.Form ||= {}

class SiteFull.Deployments.Form
  constructor: ->
    @provider_selection = new SiteFull.Deployments.ProviderSelection

  init: ->
    @provider_selection.init()
