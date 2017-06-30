require 'globe_connect'
require 'webmock/rspec'

BASE_URL = 'https://devapi.globelabs.com.ph'

def stub_post(path)
  stub_request(:post, BASE_URL + path)
end

def a_post(path)
  a_request(:post, BASE_URL + path)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def request_headers
  {'Content-Type'=>'application/json', 'Host'=>'devapi.globelabs.com.ph'}
end
