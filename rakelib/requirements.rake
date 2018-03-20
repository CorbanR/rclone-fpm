def check_ruby_version
  unless RUBY_VERSION >= "2.3"
    STDERR.puts "Please upgrade your version of Ruby, 2.5 is recommended"
    exit 1
  end
end

def gem_installed?(gem)
  Gem::Specification.find_all_by_name(gem).any?
end

def check_required_gems
  required_gems = ["fpm", "packagecloud-ruby", "rubyzip"]

  required_gems.each do |gem|
    unless gem_installed?(gem)
      STDERR.puts <<-ERR
      #{gem} gem is required.
      please run 'gem install bundler && bundle install'
      ERR
      exit 1
    end
  end
end


def config_set?
  packagecloud_config
  @packagecloud_config.none? {|k,v| v.nil? }
end

def check_required_config
  unless config_set?
    STDERR.puts "Please ensure required envrionment variables are set or config file exists.\nSee README.md for more information."
    exit 1
  end
end
