module Segment
  module Scopes
    module ControllerExtension
      private

        def segment(view)
          @scopes = Scope.for_view(view)
          @scope  = Scope.for_param(@scopes, params[:scope])
          query   = @scope.build_query(params.to_unsafe_h.fetch(:q, {}), send(Segment::Scopes.current_user_method))
          @q = @scope.model_name.classify.safe_constantize.ransack(query)
        end
    end
  end
end
