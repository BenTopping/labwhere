# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ajaxError (e, XHR, options) ->
  if(XHR.status == 401)
    $("#flash").show()
    $("#flash").append("<div class='alert'><p>"+ XHR.responseText + "</p></div>")
    $(".alert").fade(15000)
