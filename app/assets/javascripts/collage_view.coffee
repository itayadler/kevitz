class Kz.CollageView
  constructor: ->
    Kz.vent.on 'search', @addAlbums

  addAlbums: (e, albums) ->
    freeCells = $('.grid-cell').not '.occupied'
    freeCells.each (i, cell) ->
      thumbUrl = albums[i]?.artworkUrl100
      coverUrl = albums[i]?.artworkUrl600

      if thumbUrl && coverUrl
        $(cell)
          .addClass('occupied')
          .data('coverUrl', coverUrl)

        $thumb = $('<img>', width: 80, height: 80, class: 'grid-cell-image').on 'load', ->
          $thumb.appendTo cell
          setTimeout (-> $thumb.addClass 'fall'), 300 * Math.random()

        $thumb.attr 'src', thumbUrl

  #render: ->
