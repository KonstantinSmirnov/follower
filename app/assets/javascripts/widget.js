$(document).on('turbolinks:load', function() {

  $('#widget_script_status_button').on('click', function() {
    $('#widget_script_status_button').html('Checking...');
    $('#widget_script_status_button').attr('class', 'btn btn-primary');
  });

})
