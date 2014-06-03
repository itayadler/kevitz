#= require bower/typeahead.js/dist/typeahead.bundle.js
#= require bower/lodash/dist/lodash.underscore.js

class Kz.SearchView

  MAX_SUGGESTIONS: 5

  render: ->
    covers = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value')
      queryTokenizer: Bloodhound.tokenizers.whitespace
      limit: 64
      remote: 
        rateLimitWait: 100
        url: 'https://itunes.apple.com/search?term=%QUERY&entity=album&media=music&country=us&limit=64'
        filter: (parsedResponse) => @filterResults(parsedResponse)
        ajax:
          dataType: 'jsonp'
    )
    covers.initialize()
    console.log covers.ttAdapter.toString()
    $('.typeahead').typeahead null,
      name: 'covers'
      source: (query, render)=>
        covers.get(query, (result)=>
          render(_.first(result, @MAX_SUGGESTIONS))
        )
      templates:
        suggestion: JST['search_view/autocomplete/suggestion']
        footer: JST['search_view/autocomplete/footer']
    $('.typeahead').on('typeahead:selected', (e, suggestion, name)->
      Kz.vent.trigger('search', [[suggestion.data]])
    )
    Kz.vent.on('typeahead:footer-clicked', (e, query)->
      covers.get(query, (result)->
        Kz.vent.trigger('search', [_.pluck(result, 'data')])
        $('.typeahead').typeahead 'destroy'
      )
    )

  filterResults: (parsedResponse)->
    _.map(parsedResponse.results, (result)->
      result.artworkUrl600 = result.artworkUrl100.replace /100x100/, '600x600'
      data: result
      thumbnailUrl: result.artworkUrl100
      artistName: result.artistName
      albumName: result.collectionName
    )
