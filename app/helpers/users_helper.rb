module UsersHelper
  def user_form_button
    case params[:action]
    when 'new', 'create'
      '登録'
    when 'edit', 'update'
      '更新'
    else
      raise 'unexpected action'
    end
  end
end
