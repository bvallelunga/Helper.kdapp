class HelperMainView extends KDView

  constructor:(options = {}, data)->
    options.cssClass = 'Helper main-view'
    super options, data

  viewAppended:->
    @addSubView new KDView
      partial  : "helper"
      cssClass : "button"
      click    : @bound "helperModal"

  helperModal:->
    @modal.destroy() if @modal?

    @modal = new KDModalViewWithForms
      title                   : "Koding Support"
      overlay                 : yes
      overlayClick            : yes
      width                   : 700
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
          @modal = undefined
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
    KD.userAccount.fetchPlansAndSubscriptions({}).then (objects)->
      KD.userAccount.fetchEmail().then (email)=>
        message += """

        ----------------------------------------
        User ID: #{KD.nick()}
        User Agent: #{navigator.userAgent}
        User Plans: #{ [plan.description for plan in objects.plans].join ", " }
        """

        # Replace with KD.userAccount....
        # when Senthil creates the method endpoint
        console.log message
