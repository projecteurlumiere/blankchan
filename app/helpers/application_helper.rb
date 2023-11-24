module ApplicationHelper
  def truncate_image_name(image, n = 5, omission = "...")
    reversed_name = image.filename.to_s.reverse
    reversed_extension = reversed_name.match(/\w+\./).to_s
    "#{reversed_name.sub(reversed_extension, "").reverse.truncate(n, omission: omission)}#{reversed_extension.reverse}"
  end
end
