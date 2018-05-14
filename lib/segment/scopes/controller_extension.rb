module Segment
  module Scopes
    module ControllerExtension
      private

        def segment(view, klass)
          @scopes = Scope.for_view(view)
          @scope  = Scope.for_param(@scopes, params[:scope])
          query   = @scope.build_query(params.to_unsafe_h.fetch(:q, {}), current_admin_user)
          @q = klass.ransack(query)
        end
    end
  end
end
