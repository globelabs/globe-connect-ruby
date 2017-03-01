
## Globe Connect for Ruby

### Setting Up

```gem install globe_connect```

### Authentication

#### Overview

If you haven't signed up yet, please follow the instructions found in [Getting Started](http://www.globelabs.com.ph/docs/#getting-started-create-an-app) to obtain an `App ID` and `App Secret` these tokens will be used to validate most of your interaction requests with the Globe APIs.

    The authenication process follows the protocols of **OAuth 2.0**. The example code below shows how you can swap your app tokens for an access token.

#### Sample Code

```ruby
require 'globe_connect'

authenticate = Authentication.new
url = authenticate.get_access_url('[app_id]')

print url

response = authenticate
  .get_access_token(
    '[app_id]',
    '[app_secret]',
    '[code]'
  )

puts response
```

#### Sample Results

```json
{
    "access_token":"1ixLbltjWkzwqLMXT-8UF-UQeKRma0hOOWFA6o91oXw",
    "subscriber_number":"9171234567"
}
```

### SMS

#### Overview

Short Message Service (SMS) enables your application or service to send and receive secure, targeted text messages and alerts to your Globe / TM subscribers.

        Note: All API calls must include the access_token as one of the Universal Resource Identifier (URI) parameters.

#### SMS Sending

Send an SMS message to one or more mobile terminals:

##### Sample Code

```ruby
require 'globe_connect'

sms = Sms.new('[access_token]', [short_code])
response = sms.send_message('[subscriber_number]', '[message]')

puts response
```

##### Sample Results

```json
{
    "outboundSMSMessageRequest": {
        "address": "tel:+639175595283",
        "deliveryInfoList": {
            "deliveryInfo": [],
            "resourceURL": "https://devapi.globelabs.com.ph/smsmessaging/v1/outbound/8011/requests?access_token=3YM8xurK_IPdhvX4OUWXQljcHTIPgQDdTESLXDIes4g"
        },
        "senderAddress": "8011",
        "outboundSMSTextMessage": {
            "message": "Hello World"
        },
        "receiptRequest": {
            "notifyURL": "http://test-sms1.herokuapp.com/callback",
            "callbackData": null,
            "senderName": null,
            "resourceURL": "https://devapi.globelabs.com.ph/smsmessaging/v1/outbound/8011/requests?access_token=3YM8xurK_IPdhvX4OUWXQljcHTIPgQDdTESLXDIes4g"
        }
    }
}
```

#### SMS Binary

Send binary data through SMS:

##### Sample Code

```ruby
require 'globe_connect'

binary = Sms.new('[access_token]', [short_code])
response = binary.send_binary_message('[subscriber_number]', '[message]', '[data_header]')

puts response
```

##### Sample Results

```json
{
    "outboundBinaryMessageRequest": {
        "address": "9171234567",
        "deliveryInfoList": {
            "deliveryInfo": [],
            "resourceURL": "https://devapi.globelabs.com.ph/binarymessaging/v1/outbound/{senderAddress}/requests?access_token={access_token}",
        "senderAddress": "21581234",
        "userDataHeader": "06050423F423F4",
        "dataCodingScheme": 1,
        "outboundBinaryMessage": {
            "message": "samplebinarymessage"
        },
        "receiptRequest": {
          "notifyURL": "http://example.com/notify",
          "callbackData": null,
          "senderName": null
        },
        "resourceURL": "https://devapi.globelabs.com.ph/binarymessaging/v1/outbound/{senderAddress}/requests?access_token={access_token}"
    }
}
```

#### SMS Mobile Originating (SMS-MO)

Receiving an SMS from globe (Mobile Originating - Subscriber to Application):

##### Sample Code

```ruby
require 'sinatra'
require 'globe_connect'

post '/inbound-sms' do
  payload = JSON.parse(request.body.read)

  print(payload)

  # do things here...
end
```

##### Sample Results

```json
{
  "inboundSMSMessageList":{
      "inboundSMSMessage":[
         {
            "dateTime":"Fri Nov 22 2013 12:12:13 GMT+0000 (UTC)",
            "destinationAddress":"tel:21581234",
            "messageId":null,
            "message":"Hello",
            "resourceURL":null,
            "senderAddress":"9171234567"
         }
       ],
       "numberOfMessagesInThisBatch":1,
       "resourceURL":null,
       "totalNumberOfPendingMessages":null
   }
}
```

### Voice

#### Overview

The Globe APIs has a detailed list of voice features you can use with your application.

#### Voice Ask

You can take advantage of Globe's automated Ask protocols to help service your customers without manual intervention for common questions in example.

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/' do
  voice = Voice.new

  voice.say('Welcome to my Tropo Web API.');

  say = voice.say('Please enter your 5 digit zip code.', {}, true)
  choices = voice.choices({ :value => '[5 DIGITS]' }, true)

  voice.ask({
      :choices => choices,
      :attempts => 3,
      :bargein => false,
      :name => 'foo',
      :required => true,
      :say => say,
      :timeout => 10
    })

  voice.on({
      :name => 'continue',
      :next => 'http://somefakehost.com:8000',
      :required => true
    })

  content_type :json
  voice.render
end
```

##### Sample Results

```json
{
    tropo: [
        {
            say: {
                value: "Welcome to my Tropo Web API."
            }
        },
        {
            ask: {
                choices: {
                    value: "[5 DIGITS]"
                },
                attempts: 3,
                bargein: false,
                name: "foo",
                required: true,
                say: {
                    value: "Please enter your 5 digit zip code."
                },
                timeout: 10
            }
        },
        {
            on: {
                event: "continue",
                next: "http://somefakehost.com:8000/",
                required: true
            }
        }
    ]
}
```

#### Voice Answer

You can take advantage of Globe's automated Ask protocols to help service your customers without manual intervention for common questions in example.

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/' do
  voice = Voice.new

  voice.say('Welcome to my Tropo Web API.')
  voice.hangup

  content_type :json
  voice.render
end
```

##### Sample Results

```json
{
    tropo: [
        {
            say: {
                value: "Welcome to my Tropo Web API."
            }
        },
        {
            hangup: { }
        }
    ]
}
```

#### Voice Ask Answer

A better sample of the Ask and Answer dialog would look like the following.

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'
require 'json'

get '/ask-test' do
  voice = Voice.new

  say = voice.say('Please enter your 5 digit zip code.', {}, true)
  choices = voice.choices({:value => '[5 DIGITS]'})

  voice.ask({
      :choices => choices,
      :attempts => 3,
      :bargein => false,
      :name => 'foo',
      :required => true,
      :say => say,
      :timeout => 10
    })

  voice.on({
      :name => 'continue',
      :next => 'http://somefakehost.com:8000',
      :required => true
    })

  content_type :json
  voice.render
end

post '/ask-answer' do
  # get data from post
  payload = JSON.parse(request.body.read)

  voice = Voice.new
  voice.say('Your zip code is ' + payload[:result][:actions][:disposition] + ', thank you!')

  content_type :json
  voice.render
end
```

##### Sample Results

```json
if path is ask?

{
    tropo: [
        {
            say: {
                value: "Welcome to my Tropo Web API."
            }
        },
        {
            ask: {
                choices: {
                    value: "[5 DIGITS]"
                },
                attempts: 3,
                bargein: false,
                name: "foo",
                required: true,
                say: {
                    value: "Please enter your 5 digit zip code."
                },
                timeout: 10
            }
        },
        {
            on: {
                event: "continue",
                next: "/askanswer/answer",
                required: true
            }
        }
    ]
}

if path is answer?

{
    tropo: [
        {
            say: {
                value: "Your zip code is 52521, thank you!"
            }
        }
    ]
}
```

#### Voice Call

You can connect your app to also call a customer to initiate the Ask and Answer features.

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/' do
  voice = Voice.new

  voice.call({
      :to => '9065263453',
      :from => 'sip:21584130@sip.tropo.net'
    })

  say = Array.new
  say << voice.say('Hello world', {}, true)
  voice.say(say)

  content_type :json
  voice.render
end
```

##### Sample Results

```json
{
    tropo: [
        {
            call: {
                to: "9065272450",
                from: "sip:21584130@sip.tropo.net"
            }
        },
        [
            {
                value: "Hello World"
            }
        ]
    ]
}
```

#### Voice Conference

You can take advantage of Globe's automated Ask protocols to help service your customers without manual intervention for common questions in example.

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/' do
  voice = Voice.new

  voice.say('Welcome to my Tropo Web API Conference Call.');

  voice.conference({
      :id => '12345',
      :mute => false,
      :name => 'foo',
      :play_tones => true,
      :terminator => '#',
      :join_prompt => voice.join_prompt({:value => 'http://openovate.com/hold-music.mp3'}, true),
      :leave_prompt => voice.join_prompt({:value => 'http://openovate.com/hold-music.mp3'}, true),
    })

  content_type :json
  voice.render
end
```

##### Sample Results

```json
{
    tropo: [
        {
            say: {
                value: "Welcome to my Tropo Web API Conference Call."
        }
        },
        {
            conference: {
                id: "12345",
                mute: false,
                name: "foo",
                playTones: true,
                terminator: "#",
                joinPrompt: {
                    value: "http://openovate.com/hold-music.mp3"
                },
                leavePrompt: {
                    value: "http://openovate.com/hold-music.mp3"
                }
            }
        }
    ]
}
```

#### Voice Event

Call events are triggered depending on the response of the receiving person. Events are used with the Ask and Answer features.

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/' do
  voice = Voice.new

  voice.say('Welcome to my Tropo Web API.')

  say1 = voice.say('Sorry, I did not hear anything', {:event => 'timeout'}, true)

  say2 = voice.say({
      :value => 'Sorry, that was not a valid option.',
      :event => 'nomatch:1'
    }, {}, true)

  say3 = voice.say({
      :value => 'Nope, still not a valid response',
      :event => 'nomatch:2'
    }, {}, true)

  say4 = voice.say({
      :value => 'Please enter your 5 digit zip code.',
      :array => [say1, say2, say3]
    }, {}, true)

  choices = voice.choices({ :value => '[5 DIGITS]' }, true)

  voice.ask({
      :choices => choices,
      :attempts => 3,
      :bargein => false,
      :required => true,
      :say => say4,
      :timeout => 5
    })

  voice.on({
      :event => 'continue',
      :next => 'http://somefakehost:8000/',
      :required => true
    })

  content_type :json
  voice.render
end
```

##### Sample Results

```json
{
tropo: [
    {
        say: {
            value: "Welcome to my Tropo Web API."
        }
    },
    {
        ask: {
                choices: {
                    value: "[5 DIGITS]"
                },
                attempts: 3,
                bargein: false,
                name: "foo",
                required: true,
                say: [
                    {
                        value: "Sorry, I did not hear anything.",
                        event: "timeout"
                    },
                    {
                        value: "Sorry, that was not a valid option.",
                        event: "nomatch:1"
                    },
                    {
                        value: "Nope, still not a valid response",
                        event: "nomatch:2"
                    },
                    {
                        value: "Please enter your 5 digit zip code."
                    }
                ],
                timeout: 5
            }
        },
        {
            on: {
                event: "continue",
                next: "http://somefakehost:8000/",
                required: true
            }
        }
    ]
}
```

#### Voice Hangup

Between your automated dialogs (Ask and Answer) you can automatically close the voice call using this feature. 

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/' do
  voice = Voice.new

  voice.say('Welcome to my Tropo Web API, thank you!')
  voice.hangup

  content_type :json
  voice.render
end
```

##### Sample Results

```json
{
    tropo: [
        {
            say: {
                value: "Welcome to my Tropo Web API, thank you!"
            }
        },
        {
            hangup: { }
        }
    ]
}
```

#### Voice Record

It is helpful to sometime record conversations, for example to help improve on the automated dialog (Ask and Answer). The following sample shows how you can use connect your application with voice record features.

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/' do
  voice = Voice.new

  voice.say('Welcome to my Tropo Web API.');

  timeout = voice.say(
    'Sorry, I did not hear anything. Please call back.',
    { :event => 'timeout'},
    true)

  say = voice.say('Please leave a message', {:array => timeout}, true);

  choices = voice.choices({:terminator => '#'}, true)

  transcription = voice.transcription({
      :id => '1234',
      :url => 'mailto:address@email.com'
    }, true)

  voice.record({
      :attempts => 3,
      :bargein => false,
      :method => 'POST',
      :required => true,
      :say => say,
      :name => 'foo',
      :url => 'http://openovate.com/globe.php',
      :format => 'audio/wav',
      :choices => choices,
      :transcription => transcription
    })

  content_type :json
  voice.render
end
```

##### Sample Results

```json
{
    tropo: [
        {
            say: {
                value: "Welcome to my Tropo Web API."
            }
        },
        {
            record: {
                attempts: 3,
                bargein: false,
                method: "POST",
                required: true,
                say: [
                    {
                        value: "Sorry, I did not hear anything. Please call back.",
                        event: "timeout"
                    },
                    {
                        value: "Please leave a message"
                    }
                ],
                name: "foo",
                url: "http://openovate.com/globe.php",
                format: "audio/wav",
                choices: {
                    terminator: "#"
                },
                transcription: {
                    id: "1234",
                    url: "mailto:charles.andacc@gmail.com"
                }
            }
        }
    ]
}
```

#### Voice Reject

To filter incoming calls automatically, you can use the following example below. 

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/' do
  voice = Voice.new

  voice.reject

  content_type :json
  voice.render
end
```

##### Sample Results

```json
{
    tropo: [
        {
            reject: { }
        }
    ]
}
```

#### Voice Routing

To help integrate Globe Voice with web applications, this API using routing which can be easily routed within your framework.

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/routing' do
  voice = Voice.new

  voice.say('Welcome to my Tropo Web API.');
  voice.on({
    :event => 'continue',
    :next => '/routing-1'
  });

  content_type :json
  voice.render
end

get '/routing-1' do
  voice = Voice.new

  voice.say('Hello from resource one!');
  voice.on({
    :event => 'continue',
    :next => '/routing-2'
  });

  content_type :json
  voice.render
end

get '/routing-2' do
  voice = Voice.new

  voice.say('Hello from resource two! thank you.');

  content_type :json
  voice.render
end
```

##### Sample Results

```json
if path is routing?

{
    tropo: [
        {
            say: {
                value: "Welcome to my Tropo Web API."
            }
        },
        {
            on: {
                next: "/VoiceSample/RoutingTest1",
                event: "continue"
            }
        }
    ]
}

if path is routing1?

{
    tropo: [
        {
            say: {
                value: "Hello from resource one!"
            }
        },
        {
            on: {
                next: "/VoiceSample/RoutingTest2",
                event: "continue"
            }
        }
    ]
}

if path is routing2?

{
    tropo: [
        {
            say: {
                value: "Hello from resource two! thank you."
            }
        }
    ]
}
```

#### Voice Say

The message you pass to `say` will be transformed to an automated voice.

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/' do
  voice = Voice.new

  voice.say('Welcome to my Tropo Web API.');
  voice.say('I will play an audio file for you, please wait.');
  voice.say({
      :value => 'http://openovate.com/tropo-rocks.mp3'
    })

  content_type :json
  voice.render
end
```

##### Sample Results

```json
{
    tropo: [
        {
            say: {
                value: "Welcome to my Tropo Web API."
            }
        },
        {
            say: {
                value: "I will play an audio file for you, please wait."
            }
        },
        {
            say: {
                value: "http://openovate.com/tropo-rocks.mp3"
            }
        }
    ]
}
```

#### Voice Transfer

The following sample explains the dialog needed to transfer the receiver to another phone number.

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/transfer' do
  voice = Voice.new

  voice.say('Welcome to my Tropo Web API, you are now being transferred.');

  e1 = voice.say({
    :value => 'Sorry, I did not hear anything.',
    :event => 'timeout'
  }, {} ,true)

  e2 = voice.say({
    :value => 'Sorry, that was not a valid option.',
    :event => 'nomatch:1'
  }, {} ,true)

  e3 = voice.say({
    :value => 'Nope, still not a valid response',
    :event => 'nomatch:2'
  }, {} ,true)

  # TODO: [e1, e2, e3]
  say = voice.say('Please enter your 5 digit zip code', {}, true)

  choices = voice.choices({:value => '[5 DIGITs]'}, true)

  ask = voice.ask({
      :choices => choices,
      :attempts => 3,
      :bargein => false,
      :name => 'foo',
      :required => true,
      :say => [e1, e2, e3, say],
      :timeout => 5
    }, true)

  ring = voice.on({
      :event => 'ring',
      :say => voice.say('http://openovate.com/hold-music.mp3', {} ,true)
    }, true)

  connect = voice.on({
      :event => 'connect',
      :ask => ask
    }, true)

  on = voice.on([ring, connect], true)

  voice.transfer({
      :to => '9271223448',
      :ring_repeat => 2,
      :on => on
    })

  content_type :json
  voice.render
end
```

##### Sample Results

```json
{
    tropo: [
        {
            say: {
                value: "Welcome to my Tropo Web API, you are now being transferred."
            }
        },
        {
            transfer: {
                to: "9053801178",
                ringRepeat: 2,
                on: [
                    {
                        event: "ring",
                        say: {
                            value: "http://openovate.com/hold-music.mp3"
                        }
                    },
                    {
                        event: "connect",
                        ask: {
                            choices: {
                                value: "[5 DIGITS]"
                            },
                            attempts: 3,
                            bargein: false,
                            name: "foo",
                            required: true,
                            say: [
                                {
                                    value: "Sorry, I did not hear anything.",
                                    event: "timeout"
                                },
                                {
                                    value: "Sorry, that was not a valid option.",
                                    event: "nomatch:1"
                                },
                                {
                                    value: "Nope, still not a valid response",
                                    event: "nomatch:2"
                                },
                                {
                                    value: "Please enter your 5 digit zip code."
                                }
                            ],
                            timeout: 5
                        }
                    }
                ]
            }
        }
    ]
}
```

#### Voice Transfer Whisper

TODO

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/' do
  voice = Voice.new

  voice.say('Welcome to my Tropo Web API, please hold while you are being transferred.');

  say = voice.say('Press 1 to accept this call or any other number to reject', {}, true);

  choices = voice.choices({
      :value => 1,
      :mode => 'dtmf'
    }, true)

  ask = voice.ask({
      :choices => choices,
      :name => 'color',
      :say => say,
      :timeout => 60
    }, true)

  connect1 = voice.on({
      :event => 'connect',
      :ask => ask
    }, true)

  connect2 = voice.on({
      :event => 'connect',
      :say => voice.say('You are now being connected', {}, true)
    }, true)

  ring = voice.on({
      :event => 'ring',
      :say => voice.say('http://openovate.com/hold-music.mp3', {}, true)
    }, true)

  connect = voice.on([ring, connect1, connect2], true)

  voice.transfer({
      :to => '9271223448',
      :name => 'foo',
      :connect => connect,
      :required => true,
      :terminator => '*'
    })

  voice.on({
      :event => 'incomplete',
      :next => '/hangup',
      :say => voice.say('You are now being disconnected', {}, true)
    })

  content_type :json
  voice.render
end
```

##### Sample Results

```json
if transfer whisper?

{
    tropo: [
        {
            say: {
                value: "Welcome to my Tropo Web API, please hold while you are being transferred."
            }
        },
        {
            transfer: {
                to: "9054799241",
                name: "foo",
                on: [
                    {
                        event: "ring",
                        say: {
                            value: "http://openovate.com/hold-music.mp3"
                        }
                    },
                    {
                        event: "connect",
                        ask: {
                            choices: {
                                value: "1",
                                mode: "dtmf"
                            },
                            name: "color",
                            say: {
                                value: "Press 1 to accept this call or any other number to reject"
                            },
                            timeout: 60
                        }
                    },
                    {
                        event: "connect",
                        say: {
                            value: "You are now being connected."
                        }
                    }
                ],
                required: true,
                terminator: "*"
            }
        },
        {
            on: {
                event: "incomplete",
                next: "/transferwhisper/hangup",
                say: {
                    value: "You are now being disconnected."
                }
            }
        }
    ]
}

if hangup?

{
    tropo: [
        {
            hangup: { }
        }
    ]
}
```

#### Voice Wait

To put a receiver on hold, you can use the following sample.

##### Sample Code

```ruby
require 'sinatra'
require 'connect_ruby'

get '/wait' do
  voice = Voice.new

  voice.say('Welcome to my Tropo Web API, please wait for a while.')
  voice.wait({
      :wait => 5000,
      :allowSignals => true
    })

  voice.say('Thank you for waiting!')

  content_type :json
  voice.render
end
```

##### Sample Results

```json
{
    tropo: [
        {
            say: {
                value: "Welcome to my Tropo Web API, please wait for a while."
            }
        },
        {
            wait: {
                milliseconds: 5000,
                allowSignals: true
            }
        },
        {
            say: {
                value: "Thank you for waiting!"
            }
        }
    ]
}
```

### USSD

#### Overview

USSD are basic features built on most smart phones which allows the phone owner to interact with menu item choices.

#### USSD Sending

The following example shows how to send a USSD request.

##### Sample Code

```ruby
require 'globe_connect'

ussd = Ussd.new('[access_token]', [short_code])
response = ussd.send_ussd_request('[subscriber_number]', '[message]', [flash])

puts response
```

##### Sample Results

```json
{
    "outboundUSSDMessageRequest": {
        "address": "639954895489",
        "deliveryInfoList": {
            "deliveryInfo": [],
            "resourceURL": "https://devapi.globelabs.com.ph/ussd/v1/outbound/21589996/reply/requests?access_token=access_token"
        },
        "senderAddress": "21580001",
        "outboundUSSDMessage": {
            "message": "Simple USSD Message\nOption - 1\nOption - 2"
        },
        "receiptRequest": {
            "ussdNotifyURL": "http://example.com/notify",
            "sessionID": "012345678912"
        },
        "resourceURL": "https://devapi.globelabs.com.ph/ussd/v1/outbound/21589996/reply/requests?access_token=access_token"
    }
}
```

#### USSD Replying

The following example shows how to send a USSD reply.

##### Sample Code

```ruby
require 'globe_connect'

ussd = Ussd.new('[access_token]', [short_code])
response = ussd.reply_ussd_request('[subscriber_number]', '[message]', '[session_id]', [flash])

puts response
```

##### Sample Results

```json
{
    "outboundUSSDMessageRequest": {
        "address": "639954895489",
        "deliveryInfoList": {
            "deliveryInfo": [],
            "resourceURL": "https://devapi.globelabs.com.ph/ussd/v1/outbound/21589996/reply/requests?access_token=access_token"
        },
        "senderAddress": "21580001",
        "outboundUSSDMessage": {
            "message": "Simple USSD Message\nOption - 1\nOption - 2"
        },
        "receiptRequest": {
            "ussdNotifyURL": "http://example.com/notify",
            "sessionID": "012345678912",
            "referenceID": "f7b61b82054e4b5e"
        },
        "resourceURL": "https://devapi.globelabs.com.ph/ussd/v1/outbound/21589996/reply/requests?access_token=access_token"
    }
}
```

### Payment

#### Overview

Your application can monetize services from customer's phone load by sending a payment request to the customer, in which they can opt to accept.

#### Payment Requests

The following example shows how you can request for a payment from a customer.

##### Sample Code

```ruby
require 'globe_connect'

payment = Payment.new(
  '[app_id]',
  '[app_secret]',
  '[access_token]'
)

response = payment.send_payment_request([amount], '[description]', '[subscriber_number]', '[reference]', '[status]')

puts response
```

##### Sample Results

```json
{
    "amountTransaction":
    {
        "endUserId": "9171234567",
        "paymentAmount":
        {
            "chargingInformation":
            {
                "amount": "0.00",
                "currency": "PHP",
                "description": "my application"
            },
            "totalAmountCharged": "0.00"
        },
        "referenceCode": "12341000023",
        "serverReferenceCode": "528f5369b390e16a62000006",
        "resourceURL": null
    }
}
```

#### Payment Last Reference

The following example shows how you can get the last reference of payment.

##### Sample Code

```ruby
require 'globe_connect'

payment = Payment.new('[app_id]', '[app_secret]')
response = payment.get_last_reference_code

puts response
```

##### Sample Results

```json
{
    "referenceCode": "12341000005",
    "status": "SUCCESS",
    "shortcode": "21581234"
}
```

### Amax

#### Overview

Amax is an automated promo builder you can use with your app to award customers with certain globe perks.

#### Sample Code

```ruby
require 'globe_connect'

amax = Amax.new('[app_id]', '[app_secret]')
response = amax.send_reward_request('[subscriber_number]', '[promo]', '[rewards_token]')

puts response
```

#### Sample Results

```json
{
    "outboundRewardRequest": {
        "transaction_id": 566,
        "status": "Please check your AMAX URL for status",
        "address": "9065272450",
        "promo": "FREE10MB"
    }
}
```

### Location

#### Overview

To determine a general area (lat,lng) of your customers you can utilize this feature.

#### Sample Code

```ruby
require 'globe_connect'

location = LocationQuery.new('[access_token]')
response = location.get_location('[subscriber_number]', [accuracy])

puts response
```

#### Sample Results

```json
{
    "terminalLocationList": {
        "terminalLocation": {
            "address": "tel:9171234567",
            "currentLocation": {
                "accuracy": 100,
                "latitude": "14.5609722",
                "longitude": "121.0193394",
                "map_url": "http://maps.google.com/maps?z=17&t=m&q=loc:14.5609722+121.0193394",
                "timestamp": "Fri Jun 06 2014 09:25:15 GMT+0000 (UTC)"
            },
            "locationRetrievalStatus": "Retrieved"
        }
    }
}
```

### Subscriber

#### Overview

Subscriber Data Query API interface allows a Web application to query the customer profile of an end user who is the customer of a mobile network operator.

#### Subscriber Balance

The following example shows how you can get the subscriber balance.

##### Sample Code

```ruby
require 'globe_connect'

subscriber = Subscriber.new('[access_token]')
response = subscriber.get_subscriber_balance('[subscriber_number]')

puts response
```

##### Sample Results

```json
{
    "terminalLocationList":
    {
        "terminalLocation":
        [
            {
                address: "639171234567",
                subBalance: "60200"
            }
        ]
    }
}
```

#### Subscriber Reload

The following example shows how you can get the subscriber reload amount.

##### Sample Code

```ruby
require 'globe_connect'

subscriber = Subscriber.new('[access_token]')
response = subscriber.get_subscriber_reload_amount('[subscriber_number]')
```

##### Sample Results

```json
{
    "terminalLocationList":
    {
        "terminalLocation":
        [
            {
                address: "639171234567",
                reloadAmount: "30000"
            }
        ]
    }
}
```
