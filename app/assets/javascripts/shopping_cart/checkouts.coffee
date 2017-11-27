$(document).ready ->
  $('#check_clone').change (event) ->
    event.preventDefault()
    $('#shipping_form').toggle()