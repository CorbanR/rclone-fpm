require 'packagecloud'

def client
  credentials = Packagecloud::Credentials.new(@packagecloud_config[:packagecloud_username], @packagecloud_config[:packagecloud_api_key])
  Packagecloud::Client.new(credentials)
end

def check_repository
  unless client.repository(@packagecloud_config[:packagecloud_repository]).succeeded
    puts "creating #{@packagecloud_config[:packagecloud_repository]} repository as it doesn't exist"
    client.create_repository(@packagecloud_config[:packagecloud_repository])
  end
end

def push_package(repo, package, dists)
  dists.each do |dist|
    uploaded_package = client.put_package(repo, Packagecloud::Package.new(:file => package), dist)

    if uploaded_package.succeeded
      puts "Package #{package} #{dist}, was uploaded successfully."
    else
      puts uploaded_package.response
    end
  end
end
