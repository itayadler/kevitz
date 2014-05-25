class Kz.App
  @start: ->
    headerView = new Kz.HeaderView
    collageView = new Kz.CollageView
    headerView.render()
    collageView.render()

$ ->
  Kz.App.start()
