module Segment
  module Scopes
    class Scope
      attr_accessor :id, :view, :default, :hidden, :name, :filters, :model_name

      def initialize(attrs = {})
        attrs.each do |k, v|
          public_send("#{k}=", v) if respond_to?("#{k}=")
        end
      end

      def self.for_view(view)
        client = Contentful::Client.new(
          space: Segment::Scopes.contentful_space,
          access_token: Segment::Scopes.contentful_access_token,
          dynamic_entries: :auto
        )
        response = client.entries("content_type" => "scope", "fields.view" => view)
        response.map(&:fields).map { |attrs| new(attrs) }
      rescue
        []
      end

      def self.for_param(scopes, param)
        scopes.find { |s| param.blank? ? s.default : s.name == param } || new(filters: {})
      end

      def model_name
        @model_name ||= view
      end

      def build_query(search_query, user)
        filters_for_user(user).merge(search_query)
      end

      def filters_for_user(user)
        filters.inject({}) do |h, (k, v)|
          if v == "current_user_id" && user
            v = user.id
          elsif k.to_s.ends_with?("_in", "_any", "_all")
            v = v.split(", ")
          elsif matches = /\A(\d*)[. ](day|days|month|months|year|years)[. ]ago\z/.match(v.to_s)
            v = matches[1].to_i.send(matches[2]).ago.to_date
          end

          h[k] = v unless v == "current_user_id"
          h
        end
      end
    end
  end
end
