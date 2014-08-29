var request = require("request");
var express = require('express');
var app = express();
var bodyParser = require('body-parser')

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

var baseUrl = "https://api.helpscout.net/v1"
var key = "f3cb56d4a315089c19800eccbedd11c2b324c7c7"

app.post('/', function(req, res) {
  request({
    method: "POST",
    url: baseUrl + '/conversations.json',
    auth: {
      user: key,
      pass: 'x',
      sendImmediately: false
    },
    json: {
      "type": "email",
      "customer": {
          "email": req.param("email"),
          "type": "customer"
      },
      "subject": req.param("subject"),
      "mailbox": {
          "id": 19295,
          "name": "Support"
      },
      "threads": [
          {
              "type": "customer",
              "createdBy": {
                  "email": req.param("email"),
                  "type": "customer"
              },
              "body": req.param("message")
          }
      ]
    }
  }, function(error, response, body) {
    if(error || body) {
      return console.error(error, body)
      res.json(body);
    }

    res.send('success');
  })
});

app.listen(3001);
