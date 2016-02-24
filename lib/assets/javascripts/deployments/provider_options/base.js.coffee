window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.ProviderOptions ||= {}
window.SiteFull.Deployments.ProviderOptions.Base ||= {}

class SiteFull.Deployments.ProviderOptions.Base

  constructor: ->
    @instance_wrapper = '.options:visible'

  add_options_to: (select, options) ->
    select.find('option:not([value=""])').remove()
    $.each options, (i, option) ->
      select.append $('<option/>').val(option.id).text(option.name)

  enable_instance_inputs: ->
    $(':input:visible:disabled', @instance_wrapper).prop(disabled: false)

  enable_instance_input: (cls)->
    $(':input:visible:disabled', "#{@instance_wrapper} .#{cls}").prop(disabled: false)

  disable_instance_inputs: ->
    $(':input:visible:not(:disabled)', @instance_wrapper).val('').prop(disabled: true)

  get_data_for: (type) ->
    $.ajax
      beforeSend: -> $('body').addClass('loading')
      url: $(@instance_wrapper).data?("#{type}-url")
      dataType: 'json'
      method: 'post'
      data: $(':input:not(:disabled):not([name="_method"])').serializeArray()
    .done( (data) =>
      @add_options_to $('select', "#{@instance_wrapper} .#{type}"), data.items
    )
