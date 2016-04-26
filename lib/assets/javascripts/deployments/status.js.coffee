window.SiteFull ||= {}
window.SiteFull.Deployments ||= {}
window.SiteFull.Deployments.Status ||= {}

class SiteFull.Deployments.Status
  @dispatcher = null
  @channel = null
  @deployment_id

  constructor: (options = {}) ->
    host = options.host || 'localhost'
    port = options.port || '3001'
    channel = options.channel || 'deployments'
    @deployment_id = parseInt(options.deployment_id)
    @dispatcher = new WebSocketRails("#{host}:#{port}/websocket")
    @channel = @dispatcher.subscribe channel
    @restart_button = '.restart'

  trigger: ->
    @dispatcher.trigger 'deployments.created', deployment_id: @deployment_id

  init: (trigger) ->
    @trigger() if trigger
    @$deployment_container = $('#deployment-information')
    @bind_restart()
    @bind_progress()
    @bind_output()
    @bind_status()

  bind_restart: ->
    $(document).on 'click', @restart_button, (e) =>
      e.preventDefault()
      e.stopPropagation()
      @$deployment_container
        .removeClass('running')
        .removeClass('failed')
        .removeClass('completed')
        .removeClass('instance-missing')
        .addClass('running')
        .find('.restart')
        .addClass('hidden')
      @_hide_errors()
      $('.status').find('pre').addClass('hidden')
      @trigger()

  bind_progress: ->
    @channel.bind 'progress', (data) =>
      if data.id == @deployment_id
        @$container ||= $('.status .panel-body')
        $element = @$container.find("##{data.key}")
        $element.removeClass('hidden')
        if $element.length == 0
          $element = $('<pre/>').prop('id', data.key)
          @$container.append $element
        $element.text(data.message)
        $element.prop('class', data.status)
        if data.status == 'completed' || data.status == 'running'
          $(@restart_button).addClass('hidden')
          @_hide_errors()
        else
          $(@restart_button).removeClass('hidden')
          @_show_errors data.error

  bind_output: ->
    @channel.bind 'output', (data) =>
      if data.id == @deployment_id
        @next_wrap ||= true
        $container = $('.script-output')
        $container.show() unless $container.is(':visible')

        if /\r\n$/.exec(data.message)
          $('.panel-body', $container).append($('<pre/>').html(data.message))
        else
          wrapper = $('.panel-body pre:last-child', $container)
          if wrapper.length > 0
            last.html(data.message)
          else
            $('.panel-body', $container).append($('<pre/>').html(data.message))

        $('html, body').animate({
          scrollTop: $('.panel-body pre:last-child', $container).offset().top
        }, 100)

  bind_status: ->
    @channel.bind 'status', (data) =>
      if data.id == @deployment_id
        console.log data
        @$deployment_container
          .removeClass('running')
          .removeClass('failed')
          .removeClass('completed')
          .removeClass('instance-missing')
          .addClass(data.status)
          .find('.state')
          .prop('class', "state #{data.status}")
          .text(data.status)

  _hide_errors: ->
    @$deployment_container.find('.error-placeholder').addClass('hidden')

  _show_errors: (error) ->
    @$deployment_container.find('.error-placeholder')
      .removeClass('hidden')
      .find('.error .message')
      .text(error)

