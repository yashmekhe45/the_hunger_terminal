# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
    

  $(document).on "change", ".item-qty",->

    quantity = parseInt($(this).val())
    product  = $(this).parent().parent()
    
    price    = parseInt(product.find('.price').text())
    product_name  = product.find(".product-name").text()
    vendor_name   = product.find(".vendor-name").text()
    product.find(".sub-total").text(quantity * price)
    menu_item_id = product.find('.menu_item_id').text()
    order_detail_id = product.find('.order_detail_id').text()
    
    order_detail = {}
    order_detail.menu_item_name = product_name
    order_detail.vendor_name  = vendor_name
    order_detail.total  = (quantity * price)
    order_detail.quantity = quantity
    order_detail.menu_item_id = menu_item_id
    order_detail.price = price
    order_detail.id = order_detail_id
    render_menu_item_detail(order_detail)

  $(document).on 'click', '.delete', ->
    $(this).parent().parent().remove()
    text=$(this).parent().parent().attr('data-menu-item-id')
    $("table").find("#"+text).find('.sub-total').text(' 0.00')
    $("table").find("#"+text).find('.item-qty').val('0')

    sum = 0
    arr = $('.total')
    $.each arr, (key, value) ->
      num=parseInt($(value).text())
      sum += num

    $('#total').text(sum)
    $('#order_total_cost').val(sum)

  
@load_orders_data = (order_details) ->
  console.log(order_details)
  $.each order_details, (i, order_detail) ->
    render_menu_item_detail(order_detail)


render_menu_item_detail = (order_detail) ->
  selected_item = $('.order-details').find('*[data-menu-item-id="'+  order_detail.menu_item_id + '"]')
  if selected_item.length
    selected_item.find('#order_detail_qty').val(order_detail.quantity)
    selected_item.find('.total').text(order_detail.quantity*order_detail.price)
  else
    template = $("#order_detail_template").html()
    order_detail.total = order_detail.quantity * order_detail.price
    od       = Mustache.render(template, order_detail)
    $('.order-details').append(od) 

  if order_detail.quantity == 0
    $(".order-details").find(".row[data-menu-item-id=#{parseInt(order_detail.menu_item_id)}]").remove()
 
  sum = 0
  arr = $('.total')
  $.each arr, (key, value) ->
    num=parseInt($(value).text())
    sum += num

  $('#total').text(sum)
  $('#order_total_cost').val(sum)
  # $('#order_terminal').text(vendor_name)
