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

    listItems = $.map @popularTopics, (topic)->
      return """
        <li>
          <a href="#{topic.link}" target="_blank">#{topic.name}</a>
        </li>
      """
    .join("")

    @modal = new KDModalViewWithForms
      title                   : "Koding Support"
      overlay                 : yes
      overlayClick            : yes
      width                   : 700
      height                  : "auto"
      content                 : """
        <div class="container">
          <div class="topics-header">Here's a quick list of popular help topics:</div>
          <ul>#{listItems}</ul>
          <div class="message-footer">
            Still need help, check out <a href="http://learn.koding.com/faq/" target="_blank">Koding FAQs</a>
            for more info.
          </div>
        </div>
      """
      cssClass                : "new-kdmodal"
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
