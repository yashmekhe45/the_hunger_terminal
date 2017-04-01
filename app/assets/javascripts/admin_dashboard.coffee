# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
confirmation = ->
  $("#myConfirmModal").on 'click', '.btn-info', (e) ->
    debugger;
    element = $(this)
    $.ajax({
      type: "GET"
      url: "/admin_dashboard/place_orders"
      data: {
          terminal_id: $(this).data("terminal-id")
          message: $("#message").val()
      }
      success: (e)->
        $("#myConfirmModal").modal('hide');
        window.location.reload()
    });
$(document).on('turbolinks:load', confirmation)