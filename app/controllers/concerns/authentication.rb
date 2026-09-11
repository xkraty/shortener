module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
    helper_method :current_user
  end

  class_methods do
    # For login / signup pages — redirect away if already logged in.
    def require_unauthenticated_access(**options)
      allow_unauthenticated_access(**options)
      before_action :redirect_authenticated_user, **options
    end

    # For public pages that don't require a signed-in user.
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
      before_action :resume_session, **options
    end
  end

  private
    def authenticated?
      Current.user.present?
    end

    def current_user
      Current.user
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      return unless (session = find_session_by_cookie)
      set_current_session(session)
    end

    def find_session_by_cookie
      Session.find_signed(cookies.signed[:session_token])
    end

    def request_authentication
      # `request.get?` is false for HEAD even though Rails routes it like GET,
      # so a HEAD request landing here would remember nothing to return to.
      session[:return_to_after_authenticating] = request.url if request.get? || request.head?
      redirect_to new_session_path
    end

    def start_new_session_for(user)
      user.sessions.create!(
        user_agent: request.user_agent,
        ip_address: request.remote_ip
      ).tap { |session| set_current_session(session) }
    end

    def set_current_session(session)
      Current.session = session
      cookies.signed.permanent[:session_token] = {
        value: session.signed_id,
        httponly: true,
        same_site: :lax
      }
    end

    def terminate_session
      Current.session&.destroy
      cookies.delete(:session_token)
    end

    def redirect_authenticated_user
      redirect_to root_path if authenticated?
    end
end
