class HelperMainView extends KDView

  constructor:(options = {}, data)->
    @helpScoutKey = btoa "f148161d4f55f6e359db6c110dcaec6eb2b5bebc:x"
    @helpScout = "https://api.helpscout.net/v1"
    @popularTopics = [
        "name": "What Is My Sudo Password?"
        "link": "http://learn.koding.com/faq/what-is-my-sudo-password"
      ,
        "name": "What Ports Are Open On My Koding VM?"
        "link": "http://learn.koding.com/faq/open-ports"
      ,
        "name": "How Do Turn Off My My Koding VM?"
        "link": "http://learn.koding.com/faq/vm-poweroff"
    ]

    options.cssClass = 'Helper main-view'
    super options, data

  viewAppended:->
    @addSubView new KDView
      partial  : "helper"
      cssClass : "button"
      click    : => @helperModal()

  helperModal:->
    @modal.destroy() if @modal?

    container = new KDCustomHTMLView

    container.addSubView new KDCustomHTMLView
      cssClass: "topics-header"
      partial : "Here's a quick list of popular help topics:"

    container.addSubView list = new KDCustomHTMLView
      tagName : "ul"

    for topic in @popularTopics
      list.addSubView item = new KDCustomHTMLView
        tagName : "li"

      item.addSubView new KDCustomHTMLView
        tagName     : "a"
        partial     : topic.name
        attributes  :
          href  : topic.link
          target: "_blank"

    container.addSubView message = new KDCustomHTMLView
      cssClass: "message-footer"
      partial : "Still need help? Check out "

    message.addSubView new KDCustomHTMLView
      tagName     : "a"
      partial     : "Koding FAQs"
      attributes  :
        href  : "http://learn.koding.com/faq/"
        target: "_blank"

    message.addSubView message = new KDCustomHTMLView
      tagName : "span"
      partial : " or "

    message.addSubView @questionLink = new KDCustomHTMLView
      tagName : "span"
      partial : "ask us a question here"
      cssClass: "link"
      click   : => @formModal()

    message.addSubView new KDCustomHTMLView
      tagName : "span"
      partial : "."

    @modal = new KDModalView
      title           : "Koding Support"
      overlay         : yes
      overlayClick    : yes
      width           : 500
      height          : "auto"
      cssClass        : "new-kdmodal"
      view            : container

  formModal:->
    @modal.destroy() if @modal?

    @modal = new KDModalViewWithForms
      title           : "Koding Support"
      overlay         : yes
      overlayClick    : yes
      width           : 500
      height          : "auto"
      cssClass        : "new-kdmodal"
      tabs                    :
        navigable             : yes
        callback              : (form)=>
          @modal.destroy()
          delete @modal
          @submitForm form.subject, form.message
        forms                 :
          "Koding Passwords"  :
            buttons           :
              submit          :
                title         : "Submit"
                style         : "modal-clean-green"
                type          : "submit"
            fields            :
              subject         :
                type          : "text"
                placeholder   : "Subject about your problem..."
                validate      :
                  rules       :
                    required  : yes
              message         :
                type          : "textarea"
                placeholder   : """
                  Detailed message about your problem. If it is a techincal issue, please also provide what caused the issue.
                """
                validate      :
                  rules       :
                    required  : yes

  submitForm: (subject, message)->
    {profile} = KD.userAccount

    KD.userAccount.fetchEmail().then (emails)=>
      customer = {
        firstName: profile.firstName
        lastName: profile.lastName
        email: emails[0]
        type: "customer"
      }

      $.ajax
        url: "#{@helpScout}/mailboxes.json"
        type: "GET"
        beforeSend: (xhr)=>
          xhr.setRequestHeader "Authorization", "Basic #{@helpScoutKey}"
      .done (results)=>
        mailbox = results.items[0]

        $.ajax
          type: "POST"
          crossDomain: true
          url: "#{@helpScout}/conversations.json"
          contentType: "application/json"
          beforeSend: (xhr)=>
            xhr.setRequestHeader "Authorization", "Basic #{@helpScoutKey}"
          data:
            conversation:
              customer: customer
              subject: subject
              mailbox: mailbox
              threads: [
                type: "customer"
                createdBy: customer
                body: message
              ]
        .done ->
          console.log arguments

        .fail ->
          console.log arguments

      .fail ->
          console.log arguments
