module TiersHelper
  def tier_form_button
    case params[:action]
    when 'new'
      '作成'
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
