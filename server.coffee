request = require "request"
express = require "express"
bodyParser = require "body-parser"
app = express()

app.use bodyParser.urlencoded extended: false
app.use bodyParser.json()

baseUrl = "https://api.helpscout.net/v1"
key = "f3cb56d4a315089c19800eccbedd11c2b324c7c7"

# Sentil: Start Copy
app.post "/", (req, res)->
  request
    method: "POST"
    url: "#{baseUrl}/conversations.json"
    auth:
      user: key
      pass: "x"
      sendImmediately: false

    json:
      type: "email"
      customer:
          email: req.param "email"
          type: "customer"

      subject: req.param "subject"
      mailbox:
          id: 19295
          name: "Support"
      ,
      threads: [
        type: "customer"
        createdBy:
            email: req.param "email"
            type: "customer"
        ,
        body: req.param "message"
      ]
  , (error, response, body)->
    if error || body
      console.error error, body
      return res.json body

    res.send "success"

# Sentil: End Copy

app.listen 3001
