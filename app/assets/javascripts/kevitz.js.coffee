# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
class Kevitz.App
  @start: ->
    headerView = new Kevitz.HeaderView
    collageView = new Kevitz.CollageView
    headerView.render()
    collageView.render()

$ ->
  Kevitz.App.start()
