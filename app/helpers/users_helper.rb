module UsersHelper
  def user_form_button
    case params[:action]
    when 'new'
      '登録'
    when 'edit'
      'Update'
    when 'create'
      '登録'
    when 'update'
      'Update'
    else
      raise 'unexpected action'
    end
  end
end