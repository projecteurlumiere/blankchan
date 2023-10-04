class PostDecorator < ApplicationDecorator
  delegate_all

  def created_at
    model.created_at.strftime("%m/%d/%y %A %k:%l:%S")
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
