class Kevitz.SearchView
  render: ->
    $search = $('#search-form')
    $search.submit ->
      $.ajax
        url: '/find_covers_by_artist'
        type: 'get'
        data: $search.serializeArray()
        success: (albums) ->
          freeCells = $('.grid-cell').not '.occupied'
          freeCells.each (i, cell) ->
            thumbUrl = albums[i]?.artworkUrl100
            coverUrl = albums[i]?.large_cover

            if thumbUrl && coverUrl
              $(cell) #.css('background-image', "url(#{ thumbUrl })")
                .addClass('occupied')
                .data('coverUrl', coverUrl)

              $thumb = $('<img>', width: 80, height: 80, class: 'grid-cell-image').on 'load', ->
                $thumb.appendTo cell
                setTimeout (-> $thumb.addClass 'fall'), 300 * Math.random()

              $thumb.attr 'src', thumbUrl
      false
