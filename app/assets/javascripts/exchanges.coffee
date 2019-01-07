$(document).ready ->
  $('#bla').click ->
    aux = $('[name=source_currency]').val()
    $('[name=source_currency]').val($('[name=target_currency]').val())
    $('[name=target_currency]').val(aux)

  $('#amount').on 'input', ->
    $.ajax '/convert',
      type: 'GET'
      dataType: 'json'
      data: {
              source_currency: $("#source_currency").val(),
              target_currency: $("#target_currency").val(),
              amount: $("#amount").val()
            }
      error: (jqXHR, textStatus, errorThrown) ->
        alert textStatus
      success: (data, text, jqXHR) ->
        $('#result').val(data.value)
    return false;
