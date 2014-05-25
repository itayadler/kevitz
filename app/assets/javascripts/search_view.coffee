class Kz.SearchView
  render: ->
    $search = $('#search-form').submit ->
      $.ajax
        url: '/find_covers_by_artist'
        type: 'get'
        data: $search.serializeArray()
        success: (albums) ->
          Kz.vent.trigger 'search', [albums]
      false
