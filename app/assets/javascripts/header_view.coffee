class Kevitz.HeaderView
  render: ->
    searchView = new Kevitz.SearchView
    searchView.render()
    buyView = new Kevitz.BuyView
    buyView.render()
