# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('.vrv_project.container a').pjax('[data-pjax-container]')
  # bind other events
  $('.container#content.vrv_project').bind 'pjax:start', ->
    wait()
  $('.container#content.vrv_project').bind 'pjax:end',->
    back()
  
