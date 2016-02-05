$ ->
  $(document).on 'click', '.main-nav', (e) ->
    e.preventDefault()
    $('body').toggleClass 'main-nav-active'
