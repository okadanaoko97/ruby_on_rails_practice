class ApplicationController < ActionController::Base
  layout :set_layout

  helper_method :current_staff_member

  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  include ErrorHandlers if Rails.env.production?
  rescue_from ApplicationController::Forbidden, with: :rescue403
  rescue_from ApplicationController::IpAddressRejected, with: :rescue403

  private
  def set_layout
    if params[:controller].match(%r{\A(staff|admin|customer)/})
      Regexp.last_match[1]
    else
      "customer"
    end
  end

  def rescue403(e)
    @exception = e
    render "errors/forbidden", status: 403
  end

  def reject_non_xhr
    raise ActionController::BadRequest unless request.xhr?
  end

  def current_staff_member
    if session[:staff_member_id]
      @current_staff_member ||=
        StaffMember.find_by(id: session[:staff_member_id])
    end
  end
end
