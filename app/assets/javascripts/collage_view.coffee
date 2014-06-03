#= require 'jquery.gridster'

class Kz.CollageView
  constructor: ->
    Kz.vent.on 'search', @addAlbums

    $('.grid-cell').click (e) =>
      $selected = $('.grid-cell.selected')
      $clicked = $(e.currentTarget)
      $grid = $('#grid')
      
      if $selected.length
        $selected.find('img').appendTo($clicked).siblings('img').appendTo $selected
        $selected.removeClass 'selected'
        $grid.removeClass 'editing'

      else 
        $clicked.toggleClass('selected').siblings().removeClass 'selected'
        $grid.toggleClass 'editing', $clicked.is '.selected'

    $('.grid-cell-delete').click (e) =>
      $(e.currentTarget).closest('.grid-cell').removeClass('occupied').find('img').remove()

  render: ->
    # $('#grid ul').gridster
    #   widget_margins: [1, 1]
    #   widget_base_dimensions: [80, 80]
    #   max_size_x: 8
    #   max_size_y: 8
    #   max_rows: 8
    #   max_cols: 8
    #   resize: max_size: [8, 8]

  addAlbums: (e, albums) ->
    freeCells = $('.grid-cell').not '.occupied'
    freeCells.each (i, cell) ->
      thumbUrl = albums[i]?.artworkUrl100
      coverUrl = albums[i]?.artworkUrl600

      if thumbUrl && coverUrl
        $(cell).addClass('occupied')

        $thumb = $('<img>', width: 80, height: 80, class: 'grid-cell-image')
          .on 'load', ->
            $thumb.data('coverUrl', coverUrl).appendTo cell
            setTimeout (-> $thumb.addClass 'fall'), 300 * Math.random()

        $thumb.attr 'src', thumbUrl