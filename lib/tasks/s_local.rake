desc "binds server to chosen (local) ip"

namespace :s do
  task :local do
    local_ip = File.read("#{File.dirname(__FILE__)}/local_ip.txt")
    sh "rails s -b #{local_ip}"
  end
end