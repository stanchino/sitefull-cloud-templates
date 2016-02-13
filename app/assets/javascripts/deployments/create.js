//= require dashboard
//= require select2
//= require deployments/provider_selection
//= require deployments/credentials_fields
//= require deployments/form
//= require_self


(function($) {
  var deployments_form;

  deployments_form = new SiteFull.Deployments.Form();

  $(document).on('ready', function() {
    deployments_form.init();
  })
}(jQuery));
