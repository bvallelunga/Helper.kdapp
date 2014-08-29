/* Compiled by kdc on Fri Aug 29 2014 01:23:14 GMT+0000 (UTC) */
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
    this.helpScoutKey = btoa("f148161d4f55f6e359db6c110dcaec6eb2b5bebc:x");
    this.helpScout = "https://api.helpscout.net/v1";
    this.popularTopics = [
      {
        "name": "What Is My Sudo Password?",
        "link": "http://learn.koding.com/faq/what-is-my-sudo-password"
      }, {
        "name": "What Ports Are Open On My Koding VM?",
        "link": "http://learn.koding.com/faq/open-ports"
      }, {
        "name": "How Do Turn Off My My Koding VM?",
        "link": "http://learn.koding.com/faq/vm-poweroff"
      }
    ];
    options.cssClass = 'Helper main-view';
    HelperMainView.__super__.constructor.call(this, options, data);
  }

  HelperMainView.prototype.viewAppended = function() {
    return this.addSubView(new KDView({
      partial: "helper",
      cssClass: "button",
      click: (function(_this) {
        return function() {
          return _this.helperModal();
        };
      })(this)
    }));
  };

  HelperMainView.prototype.helperModal = function() {
    var container, item, list, message, topic, _i, _len, _ref;
    if (this.modal != null) {
      this.modal.destroy();
    }
    container = new KDCustomHTMLView;
    container.addSubView(new KDCustomHTMLView({
      cssClass: "topics-header",
      partial: "Here's a quick list of popular help topics:"
    }));
    container.addSubView(list = new KDCustomHTMLView({
      tagName: "ul"
    }));
    _ref = this.popularTopics;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      topic = _ref[_i];
      list.addSubView(item = new KDCustomHTMLView({
        tagName: "li"
      }));
      item.addSubView(new KDCustomHTMLView({
        tagName: "a",
        partial: topic.name,
        attributes: {
          href: topic.link,
          target: "_blank"
        }
      }));
    }
    container.addSubView(message = new KDCustomHTMLView({
      cssClass: "message-footer",
      partial: "Still need help? Check out "
    }));
    message.addSubView(new KDCustomHTMLView({
      tagName: "a",
      partial: "Koding FAQs",
      attributes: {
        href: "http://learn.koding.com/faq/",
        target: "_blank"
      }
    }));
    message.addSubView(message = new KDCustomHTMLView({
      tagName: "span",
      partial: " or "
    }));
    message.addSubView(this.questionLink = new KDCustomHTMLView({
      tagName: "span",
      partial: "ask us a question here",
      cssClass: "link",
      click: (function(_this) {
        return function() {
          return _this.formModal();
        };
      })(this)
    }));
    message.addSubView(new KDCustomHTMLView({
      tagName: "span",
      partial: "."
    }));
    return this.modal = new KDModalView({
      title: "Koding Support",
      overlay: true,
      overlayClick: true,
      width: 500,
      height: "auto",
      cssClass: "new-kdmodal",
      view: container
    });
  };

  HelperMainView.prototype.formModal = function() {
    if (this.modal != null) {
      this.modal.destroy();
    }
    return this.modal = new KDModalViewWithForms({
      title: "Koding Support",
      overlay: true,
      overlayClick: true,
      width: 500,
      height: "auto",
      cssClass: "new-kdmodal",
      tabs: {
        navigable: true,
        callback: (function(_this) {
          return function(form) {
            _this.modal.destroy();
            delete _this.modal;
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
                placeholder: "Detailed message about your problem. If it is a techincal issue, please also provide what caused the issue.",
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
    var profile;
    profile = KD.userAccount.profile;
    return KD.userAccount.fetchEmail().then((function(_this) {
      return function(emails) {
        var customer;
        customer = {
          firstName: profile.firstName,
          lastName: profile.lastName,
          email: emails[0],
          type: "customer"
        };
        return $.ajax({
          url: "" + _this.helpScout + "/mailboxes.json",
          type: "GET",
          beforeSend: function(xhr) {
            return xhr.setRequestHeader("Authorization", "Basic " + _this.helpScoutKey);
          }
        }).done(function(results) {
          var mailbox;
          mailbox = results.items[0];
          return $.ajax({
            type: "POST",
            crossDomain: true,
            url: "" + _this.helpScout + "/conversations.json",
            contentType: "application/json",
            beforeSend: function(xhr) {
              return xhr.setRequestHeader("Authorization", "Basic " + _this.helpScoutKey);
            },
            data: {
              conversation: {
                customer: customer,
                subject: subject,
                mailbox: mailbox,
                threads: [
                  {
                    type: "customer",
                    createdBy: customer,
                    body: message
                  }
                ]
              }
            }
          }).done(function() {
            return console.log(arguments);
          }).fail(function() {
            return console.log(arguments);
          });
        }).fail(function() {
          return console.log(arguments);
        });
      };
    })(this));
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