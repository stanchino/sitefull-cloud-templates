$ ->
  setTimeout ( ->
    $('.notification [data-dismiss=alert]').alert('close')
  ), 5000
