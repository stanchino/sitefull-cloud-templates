window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderOptions ||= {}
window.SiteFull.Deployments.ProviderOptions.Factory ||= {}

class SiteFull.Deployments.ProviderOptions.Factory

  provider_options_for: (provider) ->
    if provider == 'amazon'
      new SiteFull.Deployments.ProviderOptions.Amazon
    else if provider == 'google'
      new SiteFull.Deployments.ProviderOptions.Google
