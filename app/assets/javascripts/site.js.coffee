window.print_doc = ->
  window.print()
# set loading icon position
$ ->
  $('#loading').css('left',($(window).width()-$('.container').width())/2 - 60)
