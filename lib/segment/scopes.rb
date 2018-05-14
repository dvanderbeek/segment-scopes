require "httparty"
require "segment/scopes/version"
require "segment/scopes/scope"

module Segment
  module Scopes
    mattr_accessor :base_uri
    self.base_uri = "https://segment-scopes.herokuapp.com/api"

    mattr_accessor :api_key

    def self.configure
      yield self
    end
  end
end
