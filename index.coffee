class HelperMainView extends KDView

  constructor:(options = {}, data)->
    options.cssClass = 'Helper main-view'
    super options, data

  viewAppended:->
    @addSubView new KDView
      partial  : "Welcome to Helper app!"
      cssClass : "welcome-view"

class HelperController extends AppController

  constructor:(options = {}, data)->
    options.view    = new HelperMainView
    options.appInfo =
      name : "Helper"
      type : "application"

    super options, data

do ->

  # In live mode you can add your App view to window's appView
  if appView?
    view = new HelperMainView
    appView.addSubView view

  else
    KD.registerAppClass HelperController,
      name     : "Helper"
      routes   :
        "/:name?/Helper" : null
        "/:name?/bvallelunga/Apps/Helper" : null
      dockPath : "/bvallelunga/Apps/Helper"
      behavior : "application"