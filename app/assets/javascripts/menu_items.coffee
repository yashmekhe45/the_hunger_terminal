# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.activate', (e)->
    element = $(this)
    e.preventDefault()
    $.ajax({
      url: element.attr('href+activate'),
      type: 'PATCH'
    }).done (html)->
      tr = element.parents("tr");
      tr.replaceWith(html);