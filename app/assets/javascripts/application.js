// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.

//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.es.js
//= require bootstrap-datepicker/locales/bootstrap-datepicker.fr.js

//= require jquery_ujs
//= require turbolinks
//= require jquery_nested_form
//= require toastr
//= require_tree .

  $(document).on('turbolinks:load',function(){
    $('.from').datepicker({
      autoclose: true,
      format: 'yyyy-mm-dd'
    });
    $('.to').datepicker({
      autoclose: true,
      format: 'yyyy-mm-dd'
    });
    $("#bton").click(function(event) {
      event.preventDefault();
      params = $.param({ from: $('#bton').parent().find('.from').val(),to: $('#bton').parent().find('.to').val()})
      window.location.href = '/orders' + '?' + params
    });
  });



function validateFiles(inputFile) {
  var maxExceededMessage = "This file exceeds the maximum allowed file size (1 MB)";
  var extErrorMessage = "Only image file with extension: .jpg, .jpeg, .gif or .png is allowed";
  var allowedExtension = ["jpg", "jpeg", "gif", "png"];

  var extName;
  var maxFileSize = $(inputFile).data('max-file-size');
  var sizeExceeded = false;
  var extError = false;

  $.each(inputFile.files, function() {
    if (this.size && maxFileSize && this.size > parseInt(maxFileSize)) {sizeExceeded=true;};
    extName = this.name.split('.').pop();
    if ($.inArray(extName, allowedExtension) == -1) {extError=true;};
  });
  if (sizeExceeded) {
    window.alert(maxExceededMessage);
    $(inputFile).val('');
  };

  if (extError) {
    window.alert(extErrorMessage);
    $(inputFile).val('');
  };
}



  
