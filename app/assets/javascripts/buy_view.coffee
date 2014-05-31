class Kz.BuyView
  render: ->
    $('#buy').click ->
      coverUrls = $('.grid-cell img').map -> $(@).data('coverUrl')
      $.ajax
        url: '/buy'
        method: 'post'
        data: covers: coverUrls.toArray()
        dataType: 'json'
        success: (response) ->
          location.href = response.zazzleUrl
