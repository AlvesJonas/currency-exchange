$(document).ready ->
  $('#switch-currency').click ->
    aux = $('[name=source_currency]').val()
    $('[name=source_currency]').val($('[name=target_currency]').val())
    $('[name=target_currency]').val(aux)
    call_ajax()
    return false

  $('#amount').on 'input', ->
    clearTimeout wto
    wto = setTimeout((->
      call_ajax()
    ), 1000)
    return false

  call_ajax = ->
    if $("#amount").val() != "" && $("#amount").val() != "0"
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
      return false
    
    
