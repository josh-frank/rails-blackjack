class ApplicationController < ActionController::Base

    helper_method :logged_in?, :current_player

    before_action :authorize

    def current_player
        @current_player ||= Player.find_by( id: session[ :player_id ] )
    end

    def logged_in?
        !current_player.nil?
    end

    def authorize
        redirect_to login_path unless logged_in?
    end

end
