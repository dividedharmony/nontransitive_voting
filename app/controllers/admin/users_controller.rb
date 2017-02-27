# frozen_string_literal: true

module Admin
  class UsersController < Clearance::UsersController
    skip_before_action :redirect_signed_in_users

    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new
      assign_user_from_params
      sync('User successfully created', :new)
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      assign_user_from_params
      sync('User successfully edited', :edit)
    end

    private

    def assign_user_from_params
      email = user_params.delete(:email)
      password = user_params.delete(:password)

      @user.tap do |user|
        user.email = email if email.present?
        user.password = password if password.present?
        user.admin = (user_params[:admin] == 'yes')
      end
    end

    def user_params
      params[:user]
    end

    def sync(success_message, fail_action)
      if @user.save
        flash[:success] = success_message
        redirect_to admin_edit_user_path(@user)
      else
        flash[:error] = @user.errors.full_messages
        render action: fail_action
      end
    end
  end
end
