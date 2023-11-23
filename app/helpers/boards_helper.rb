module BoardsHelper
  def board_links
    Board.order(:name).pluck(:name).map do |name|
      link_to "/#{name}/", board_path(name)
    end
  end
end