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
				freeCells.each (i) ->
					coverUrl = albums[i]?.artworkUrl100
					if coverUrl
						$(@).css('background-image', "url(#{ coverUrl })")
							.addClass('occupied')

		false

