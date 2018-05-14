require "segment/scopes/version"
require "segment/scopes/scope"

module Segment
  module Scopes
    mattr_accessor :base_uri
    self.base_uri = "https://https://segment-scopes.herokuapp.com/api"

    mattr_accessor :api_key
    self.api_key = Rails.application.credentials.align_service_api_key
  end
end
