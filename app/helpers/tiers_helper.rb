module TiersHelper
  def tier_form_button
    case params[:action]
    when 'new'
      '作成'
    when 'edit', 'update'
      'Update'
    when 'create'
      '登録'
    else
      raise 'unexpected action'
    end
  end
end
