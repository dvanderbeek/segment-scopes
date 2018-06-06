module Segment
  module Scopes
    module ControllerExtension
      private

        def segment(view, model)
          @scopes = Repo.get_scopes_for_view(view)
          @scope  = Scope.for_param(@scopes, params[:scope])
          user   = send(Segment::Scopes.current_user_method)
          if @scope.roles.any? && user.respond_to?(:has_any_role?) && !user.has_any_role?(*@scope.roles)
            redirect_to admin_root_path, flash: { alert: "Scope not authorized" }
          end
          query   = @scope.build_query(params.to_unsafe_h.fetch(:q, {}), user)
          @q = model.ransack(query)
        end
    end
  end
end
