//= require dashboard
//= require select2
//= require deployments/form
//= require_self


;(function($) {
  var deployments_form;

  deployments_form = new SiteFull.Deployments.Form();

  $(document).on('ready', function() {
    deployments_form.init();
  })
})(jQuery);
