require 'playwright'

class ScreenshotsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    begin
      # 一時的なディレクトリを使用してスクリーンショットを保存する
      tempfile = Tempfile.new(['screenshot', '.png'], Rails.root.join('tmp'))

      Playwright.create(playwright_cli_executable_path: 'npx playwright') do |playwright|
        browser = playwright.chromium.launch(headless: true)
        context = browser.new_context
        page = context.new_page
        
        page.goto('http://localhost:3000/tiers/48/edit')

        page.evaluate("document.querySelector('footer').style.display = 'none';")
        
        element = page.query_selector('#tier-container')
        if element
          element.screenshot(path: tempfile.path)
          message = "Screenshot saved"
        else
          message = "'tier-container' element not found"
        end
        
        browser.close

        session[:screenshot_path] = tempfile.path
        
        render json: { message: message }, status: :ok
      end
    rescue => e
      render json: { error: e.message, backtrace: e.backtrace[0..10] }, status: :internal_server_error
    end
  end

  def download
    filepath = session[:screenshot_path]
    pp filepath
    if filepath && File.exist?(filepath)
      pp 'download'
      send_file filepath, filename: "screenshot.png", type: "image/png"
      # ダウンロード後にファイルを削除
      # File.delete(filepath)
      session.delete(:screenshot_path)
    else
      render json: { error: 'File not found' }, status: :not_found
    end
  end
end
