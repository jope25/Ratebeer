module ApplicationHelper
  def edit_and_destroy_buttons(item)
    edit = link_to('Edit', url_for([:edit, item]), class:"btn btn-default btn-sm")
    if current_user_is_admin?
      del = link_to('Destroy', item, method: :delete,
                    data: {confirm: 'Are you sure?' }, class:"btn btn-danger btn-sm")
      raw("#{edit} #{del}")
    elsif current_user
      raw("#{edit}")
    end
  end

  def round(param)
    number_with_precision(param, precision: 1)
  end
end
