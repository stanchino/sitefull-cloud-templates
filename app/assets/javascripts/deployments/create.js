//= require dashboard
//= require select2
//= require deployments/provider_selection
//= require deployments/provider_options/base
//= require deployments/provider_options/amazon
//= require deployments/provider_options/google
//= require deployments/provider_options/factory
//= require deployments/provider_settings
//= require deployments/form
//= require_self


(function($) {
  var deployments_form;

  deployments_form = new SiteFull.Deployments.Form();

  $(document).on('ready', function() {
    deployments_form.init();
  })
}(jQuery));
