module Segment
  module Scopes
    module LinkHelper
      def scope_link(scope, current_scope)
        link_to scope.name.titleize,
          params.to_unsafe_h.merge(scope: scope.name),
          class: "btn btn-sm btn-#{scope == current_scope ? 'primary' : 'light'}"
      end
    end
  end
end
