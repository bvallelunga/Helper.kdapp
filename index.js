/* Compiled by kdc on Sat Aug 30 2014 00:50:21 GMT+0000 (UTC) */
(function() {
/* KDAPP STARTS */
if (typeof window.appPreview !== "undefined" && window.appPreview !== null) {
  var appView = window.appPreview
}
/* BLOCK STARTS: /home/bvallelunga/Applications/Helper.kdapp/main.coffee */
var HelperMainView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

HelperMainView = (function(_super) {
  __extends(HelperMainView, _super);

  function HelperMainView(options, data) {
    if (options == null) {
      options = {};
    }
    options.cssClass = 'Helper main-view';
    HelperMainView.__super__.constructor.call(this, options, data);
  }

  HelperMainView.prototype.viewAppended = function() {
    return this.addSubView(new KDView({
      partial: "helper",
      cssClass: "button",
      click: this.bound("helperModal")
    }));
  };

  HelperMainView.prototype.helperModal = function() {
    if (this.modal != null) {
      this.modal.destroy();
    }
    return this.modal = new KDModalViewWithForms({
      title: "Koding Support",
      overlay: true,
      overlayClick: true,
      width: 700,
      content: "<div class=\"container\">\n  <div class=\"topics-header\">Here's a quick list of popular help topics:</div>\n  <ul>\n    <li><a href=\"http://learn.koding.com/faq/what-is-my-sudo-password\" target=\"_blank\">What Is My Sudo Password?</a></li>\n    <li><a href=\"http://learn.koding.com/faq/open-ports\" target=\"_blank\">What Ports Are Open On My Koding VM?</a></li>\n    <li><a href=\"http://learn.koding.com/faq/vm-poweroff\" target=\"_blank\">How Do Turn Off My My Koding VM?</a></li>\n  </ul>\n  <div class=\"message-footer\">\n    Still need help? Check out <a href=\"http://learn.koding.com/faq/\" target=\"_blank\">Koding FAQs</a>\n    for more info.\n  </div>\n</div>",
      cssClass: "new-kdmodal",
      tabs: {
        navigable: true,
        callback: (function(_this) {
          return function(form) {
            _this.modal.destroy();
            _this.modal = void 0;
            return _this.submitForm(form.subject, form.message);
          };
        })(this),
        forms: {
          "Koding Passwords": {
            buttons: {
              submit: {
                title: "Submit",
                style: "modal-clean-green",
                type: "submit"
              }
            },
            fields: {
              subject: {
                type: "text",
                placeholder: "Subject about your problem...",
                validate: {
                  rules: {
                    required: true
                  }
                }
              },
              message: {
                type: "textarea",
                placeholder: "Detailed message about your problem. If it is a techincal issue, please also provide what caused the issue and a link to a screenshot.",
                validate: {
                  rules: {
                    required: true
                  }
                }
              }
            }
          }
        }
      }
    });
  };

  HelperMainView.prototype.submitForm = function(subject, message) {
    return KD.userAccount.fetchPlansAndSubscriptions({}).then(function(objects) {
      return KD.userAccount.fetchEmail().then((function(_this) {
        return function(email) {
          var plan;
          message += "\n----------------------------------------\nUser ID: " + (KD.nick()) + "\nUser Agent: " + navigator.userAgent + "\nUser Plans: " + ([
            (function() {
              var _i, _len, _ref, _results;
              _ref = objects.plans;
              _results = [];
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                plan = _ref[_i];
                _results.push(plan.description);
              }
              return _results;
            })()
          ].join(", "));
          return console.log(message);
        };
      })(this));
    });
  };

  return HelperMainView;

})(KDView);
/* BLOCK STARTS: /home/bvallelunga/Applications/Helper.kdapp/index.coffee */
var HelperController,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

HelperController = (function(_super) {
  __extends(HelperController, _super);

  function HelperController(options, data) {
    if (options == null) {
      options = {};
    }
    options.view = new HelperMainView;
    options.appInfo = {
      name: "Helper",
      type: "application"
    };
    HelperController.__super__.constructor.call(this, options, data);
  }

  return HelperController;

})(AppController);

(function() {
  var view;
  if (typeof appView !== "undefined" && appView !== null) {
    view = new HelperMainView;
    return appView.addSubView(view);
  } else {
    return KD.registerAppClass(HelperController, {
      name: "Helper",
      routes: {
        "/:name?/Helper": null,
        "/:name?/bvallelunga/Apps/Helper": null
      },
      dockPath: "/bvallelunga/Apps/Helper",
      behavior: "application"
    });
  }
})();

/* KDAPP ENDS */
}).call();