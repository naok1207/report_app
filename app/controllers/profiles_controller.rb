class ProfilesController < ApplicationController
    def edit
        @user = User.find(current_user.id)
    end

    def update
        @user = User.find(current_user.id)
        if @user.profile.update_attributes(profile_params)
            flash[:success] = "変更成功"
            redirect_to user_path(id: current_user.id)
        else
            render 'edit'
        end
    end

    private
        def profile_params
            params.require(:profile).permit(:location, :about, :image)
        end
end
