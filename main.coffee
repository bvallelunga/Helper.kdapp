class HelperMainView extends KDView

  constructor:(options = {}, data)->
    @helpScoutKey = btoa "f148161d4f55f6e359db6c110dcaec6eb2b5bebc:x"
    @helpScout = "https://api.helpscout.net/v1"

    options.cssClass = 'Helper main-view'
    super options, data

  viewAppended:->
    @addSubView new KDView
      partial  : "helper"
      cssClass : "button"
      click    : => @helperModal()

  helperModal:->
    @modal.destroy() if @modal?

    @modal = new KDModalViewWithForms
      title                   : "Koding Support"
      overlay                 : yes
      overlayClick            : yes
      width                   : 700
      height                  : "auto"
      content                 : """
        <div class="container">
          <div class="topics-header">Here's a quick list of popular help topics:</div>
          <ul>
            <li><a href="http://learn.koding.com/faq/what-is-my-sudo-password" target="_blank">What Is My Sudo Password?</a></li>
            <li><a href="http://learn.koding.com/faq/open-ports" target="_blank">What Ports Are Open On My Koding VM?</a></li>
            <li><a href="http://learn.koding.com/faq/vm-poweroff" target="_blank">How Do Turn Off My My Koding VM?</a></li>
          </ul>
          <div class="message-footer">
            Still need help? Check out <a href="http://learn.koding.com/faq/" target="_blank">Koding FAQs</a>
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
                  Detailed message about your problem. If it is a techincal issue, please also provide what caused the issue and a link to a screenshot.
                """
                validate      :
                  rules       :
                    required  : yes

  submitForm: (subject, message)->
    KD.userAccount.fetchEmail().then (email)=>
      $.post "https://bvallelunga.kd.io:3001",
        email: email
        subject: subject
        message: message
      , ->
        console.log arguments
    .catch -> console.log arguments
