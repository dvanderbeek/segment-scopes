module Segment
  module Scopes
    module ControllerExtension
      def scope_link(scope, current_scope)
        link_to scope.name.titleize,
          params.to_unsafe_h.merge(scope: scope.name),
          class: "btn btn-sm btn-#{scope == current_scope ? 'primary' : 'light'}"
      end
      helper_method :scope_link

      private

        def segment(view, klass)
          @scopes = Scope.for_view(view)
          @scope  = Scope.for_param(@scopes, params[:scope])
          query   = Scope.build_query(@scope, params.to_unsafe_h.fetch(:q, {}), current_admin_user)
          @q = klass.ransack(query)
        end
    end
  end
end
