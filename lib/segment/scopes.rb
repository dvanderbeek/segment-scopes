require "httparty"
require "segment/scopes/version"
require "segment/scopes/scope"
require "segment/scopes/controller_extension"
require "segment/scopes/link_helper"

module Segment
  module Scopes
    mattr_accessor :base_uri
    self.base_uri = "https://segment-scopes.herokuapp.com/api"

    mattr_accessor :current_user_method
    self.current_user_method = :current_user

    mattr_accessor :api_key

    def self.configure
      yield self
    end
  end
end

ActionController::Base.send :include, Segment::Scopes::ControllerExtension
ActionView::Base.send :include, Segment::Scopes::LinkHelper
