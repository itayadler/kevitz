class Kz.HeaderView
  render: ->
    searchView = new Kz.SearchView
    searchView.render()
    buyView = new Kz.BuyView
    buyView.render()
