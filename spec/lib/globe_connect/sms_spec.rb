require 'spec_helper'

describe Sms do
  describe '#send_message' do
    let(:body) do
      {
        outboundSMSMessageRequest: {
          senderAddress:'tel:short_code',
          address:['tel:subscriber_number'],
          outboundSMSTextMessage:{message:'message'}
        }
      }
    end

    before do
      stub_post('/smsmessaging/v1/outbound/short_code/requests?access_token=token').
        with(body: JSON.generate(body), headers: request_headers).
        to_return(status: 200, body: fixture('sms.json'), headers: {})
    end

    it 'returns sms response' do
      sms = Sms.new 'token', 'short_code'
      response = sms.send_message 'subscriber_number', 'message'

      expect(response['outboundSMSMessageRequest']).to be_truthy
    end

    it 'send the correct resource' do
      sms = Sms.new 'token', 'short_code'
      sms.send_message 'subscriber_number', 'message'

      expect(a_post('/smsmessaging/v1/outbound/short_code/requests?access_token=token')
        .with(body: JSON.generate(body), headers: request_headers)).to have_been_made
    end
  end
end
