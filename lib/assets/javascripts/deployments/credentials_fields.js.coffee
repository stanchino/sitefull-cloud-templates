window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.CredentialsFields ||= {}

class SiteFull.Deployments.CredentialsFields

  constructor: ->
    @wrapper = '.credentials'
    @instance_wrapper = '.instance:visible'
    @image_selector = '#deployment_image'

  init: ->
    $(@image_selector).select2
      theme: 'bootstrap'
    $(document).on 'keyup keypress blur change', "#{@wrapper} :input:visible", =>
     @toggle_fields_visibility()

  toggle_fields_visibility: =>
    if @all_values_set()
      @enable_instance_inputs()
    else
      @disable_instance_inputs()

  all_values_set: =>
    $(':input:visible', @wrapper).filter( -> return @.value == '').length == 0

  enable_instance_inputs: ->
    $(':input:visible:disabled', @instance_wrapper).prop(disabled: false)

  disable_instance_inputs: ->
    $(':input:visible:not(:disabled)', @instance_wrapper).prop(disabled: true)
