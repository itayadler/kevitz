# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
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

	$('#buy').click ->
		coverUrls = $('.grid-cell').map -> $(@).data('coverUrl')
		$.ajax
			url: '/buy'
			method: 'post'
			data: covers: coverUrls.toArray()
			dataType: 'json'
			success: (response) ->
				location.href = response.zazzleUrl
