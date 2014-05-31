#= require 'jquery.gridster'

class Kz.CollageView
  constructor: ->
    Kz.vent.on 'search', @addAlbums

  render: ->
    $('#grid ul').gridster
      widget_margins: [1, 1]
      widget_base_dimensions: [80, 80]
      max_size_x: 8
      max_size_y: 8
      max_rows: 8
      max_cols: 8
      resize: max_size: [8, 8]

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