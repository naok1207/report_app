class MessagesController < ApplicationController
    before_action :logged_in_user, only: [:new, :create, :destroy]

    def new
        @message = Message.new
    end

    def create
        @message = Message.create(content: params[:content])
    end

    def destroy
    end

    private
        def logged_in_user
            unless logged_in?
            flash[:danber] = "Please log in"
            redirect_to login_url
            end
        end
end
