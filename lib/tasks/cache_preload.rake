desc "preloads cache"

namespace :cache do
  task :preload do
    # should (pre)render all necessary templates by iterating through:
    # Controller.render :action, assigns: {variable_1: foo}
    puts "not yet implemented"
  end
end