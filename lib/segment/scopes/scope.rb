module Segment
  module Scopes
    class Scope
      attr_accessor :id, :view, :default, :hidden, :name, :filters

      def initialize(attrs = {})
        attrs.each do |k, v|
          public_send("#{k}=", v) if respond_to?("#{k}=")
        end
      end

      def self.for_view(view)
        response = HTTParty.get(
          "#{Segment::Scopes.base_uri}/scopes?view=#{view}",
          headers: { "authorization" => "Bearer #{Segment::Scopes.api_key}" }
        )
        response["data"].map { |attrs| new(attrs) }
      rescue
        []
      end

      def self.for_param(scopes, param)
        scopes.find { |s| param.blank? ? s.default : s.name == param }
      end

      # Has to be a class method since scope can be nil
      def self.build_query(scope, search_query, user)
        scope ? scope.filters_for_user(user).merge(search_query) : search_query
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
