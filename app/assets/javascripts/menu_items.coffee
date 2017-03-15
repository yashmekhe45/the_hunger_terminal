# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready -> 
  
  $(window).bind 'beforeunload', ->
    $('.qty').val('1')
    $('form.selector').hide()
  $('.btn.btn-info.btn-sm').click ->
    $(this).hide()
    $(this).parent().find('form').show()
    item = $(this).parent().find('h4').text()
    terminal = $(this).parent().find('h2').text()
    price = $(this).parent().find('span').text()
    txt4 = $(this).parent().find('form').attr('id')
    total = parseInt($('.total').text())
    $('.row.order').append("<div class='row #{txt4}'><div class='col-sm-3'>#{item}</div><div class='col-sm-3'>#{terminal}</div><div class='col-sm-3 item-count'>1</div><div class='col-sm-3 price'>#{price}</div></div>")
    
    $('.total').text(total+parseInt(price)) 
  $('.btn-block').click ->
    $('.qty').val('1')
    $('.row.order').empty()
    $('.total').empty()
    $('form.selector').hide();
    $('.btn.btn-info').show();
     
  
  $('.qtyplus').click () ->
  	currentVal = parseInt($(this).parent().find('.qty').val())
  	price = parseInt($(this).parent().parent().find('span').text())	
  	if !isNaN(currentVal)
  	  text = $(this).parent().attr('id')
    	$(".card-block").find(".#{text}").find('.item-count').text(currentVal + 1)
    	$(".card-block").find(".#{text}").find('.price').text((currentVal + 1)*price)
    	$(this).parent().find('.qty').val(currentVal + 1)  
  	else
    	$(this).parent().find('.qty').val 0
    sum = 0
  	arr = $('.card-block .price')
  	$.each arr, (key, value) ->
  		num=parseInt($(value).text())
  		sum += num
    $('.total').text(sum)		
		
    
  $('.qtyminus').click () ->
  	currentVal = parseInt($(this).parent().find('.qty').val())
  	price = parseInt($(this).parent().parent().find('span').text())
  	if !isNaN(currentVal)and currentVal > 1
  	  text = $(this).parent().attr('id')
  	  $(".card-block").find(".#{text}").find('.item-count').text(currentVal - 1)
  	  $(".card-block").find(".#{text}").find('.price').text((currentVal - 1)*price)
    	$(this).parent().find('.qty').val currentVal - 1
    else if currentVal <= 1
      text = $(this).parent().attr('id')
      $(this).parent().hide()
      $(".card-block").find(".#{text}").empty()
      $(this).parent().parent().find('.btn.btn-info').show()
  	else
    	$(this).parent().find('.qty').val 0 
    sum = 0
  	arr = $('.card-block .price')

  	$('.total').text("0") if arr.length == 0

  	$.each arr, (key, value) ->
  		num=parseInt($(value).text())
  		sum += num

    $('.total').text(sum)

