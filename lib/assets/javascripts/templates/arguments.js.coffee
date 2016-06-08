window.SiteFull ||= {}
window.SiteFull.TemplateArguments ||= {}

class SiteFull.TemplateArguments
  options:
    add_button: '.add'
    edit_button: '.edit[data-argument-id]'
    delete_button: '.delete[data-argument-id]'
    fields_container: '.argument-fields'
    fields_template: '#new-argument-fields'
    actions_container: '.argument-controls'
    actions_template: '#new-argument-actions'
    field_selector: '.argument-field'
    control_wrapper: '.input-group'
    insert_button: '.insert-argument'
    script_textarea: '#template_script'

  constructor: (options) ->
    $.extend @options, options

  init: () ->
    @$container = $(@options.fields_container)
    @_bind_insert()
    @_bind_add()
    @_bind_edit()
    @_bind_delete()
    @_bind_save()
    @_bind_cancel()

  _bind_insert: () ->
    $(document).on 'click', @options.insert_button, (e) =>
      e.preventDefault()
      $textarea = $(@options.script_textarea)
      startPos = $textarea[0].selectionStart
      endPos = $textarea[0].selectionEnd
      textAreaTxt = $textarea.val()
      textToAdd = $(e.target).data?('argument-value')
      $textarea.val textAreaTxt.substring(0, startPos) + textToAdd + textAreaTxt.substring(endPos)

  _bind_add: () ->
    $(document).on 'click', @options.add_button, (e) =>
      e.preventDefault()
      argument_id = @_next_argument_id()
      @$container.append @_new_argument_fields(argument_id)
      @_show_field "argument-#{argument_id}"

  _bind_edit: () ->
    $(document).on 'click', @options.edit_button, (e) =>
      e.preventDefault()
      argument_id = $(e.target).data?('argument-id')
      @_show_field argument_id

  _bind_save: () ->
    $(document).on 'click', "#{@options.field_selector} input[type=submit]", (e) =>
      e.preventDefault()
      $container = $(e.target).closest(@options.field_selector)
      argument_id = $container.data?('argument-id')
      if $container.attr('data-existing-argument') == undefined
        $container.attr('data-existing-argument', true)
        $(@options.actions_container).append @_new_argument_actions(argument_id)
      $("[data-argument-name=#{argument_id}]").text $container.find('input[name*="[name]"]').val()
      $container.hide()

  _bind_cancel: () ->
    $(document).on 'click', "#{@options.field_selector} .cancel", (e) =>
      e.preventDefault()
      @$container.find("#{@options.field_selector}:not([data-existing-argument])").remove()
      @$container.find(@options.field_selector).hide()

  _bind_delete: () ->
    $(document).on 'ajax:beforeSend', '.delete', (e) =>
      $target = $(e.target)
      unless $target.data?('saved')
        @_remove_argument $target
        false

    $(document).on 'ajax:success', '.delete', (e) =>
      @_remove_argument $(e.target)

    $(document).on 'ajax:error', '.delete', (e, xhr, status, error) =>
      $(document).find('body').append $("<div class=\"notification fade in\"><div class=\"error alert alert-dismissable\" role=\"alert\"><button class=\"close\" type=\"button\" aria-lable=\"Close\" data-dismiss=\"alert\" data-target=\".notification\"><span aria-hidden=\"true\"> &times;</span></button>#{error}</div></div>")

  _remove_argument: ($target) ->
    argument_id = $target.data?('argument-id')
    $target.closest(@options.control_wrapper).remove()
    $("#{@options.field_selector}[data-argument-id=#{argument_id}]").remove()

  _new_argument_fields: (argument_id) ->
    $(@options.fields_template).html().replace /new_argument/g, argument_id

  _new_argument_actions: (argument_id) ->
    $(@options.actions_template).html().replace /new_argument/g, argument_id

  _next_argument_id: () ->
    arg_ids = $(@options.field_selector).map (i, e) -> parseInt(e.getAttribute('data-argument-id').replace('argument-', ''))
    return 0 unless arg_ids.length > 0
    Math.max.apply(@, arg_ids) + 1

  _show_field: (argument_id) ->
    @$container.find("#{@options.field_selector}:not([data-existing-argument]):not([data-argument-id=#{argument_id}])").remove()
    @$container.find(@options.field_selector).hide()
    @$container.find("[data-argument-id='#{argument_id}']").modal('show')
