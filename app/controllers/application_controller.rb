class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :set_active_storage_url_options

  private

  def not_authenticated
    redirect_to login_path, danger: "ログインしてください"
  end

  def set_active_storage_url_options
    if Rails.env.test?
      ActiveStorage::Current.url_options = { protocol: 'http://', host: 'example.com', port: 80 }
    end
  end
end
