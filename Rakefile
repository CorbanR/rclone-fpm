require 'fileutils'
require 'open-uri'
require 'pp'

task :default => ["build:init"]

namespace 'build' do
  #Set root_dir = absolut path to Rakefile
  @root_dir = __dir__

  desc "Build rclone deb"
  task :deb => [:check, :init, :download] do
    command = `fpm --force -s dir -t deb -n rclone -v #{@options[:version]} --iteration #{@options[:iteration]} --url https://rclone.org/ -C #{@root_dir}/src/ -a #{@options[:arch]} --after-install #{@root_dir}/bash_scripts/after-install.sh --after-remove #{@root_dir}/bash_scripts/after-remove.sh`
    pp command
    package = command.match(/rclone.*#{@options[:version]}-#{@options[:iteration]}.*deb/).to_s

    push_package(@packagecloud_config[:packagecloud_repository], "#{@root_dir}/#{package}", @options[:dists])
  end

  desc "Build rclone rpm"
  task :rpm => [:check, :init, :download] do
    command = `fpm --force -s dir -t rpm -n rclone -v #{@options[:version]} --iteration #{@options[:iteration]} --url https://rclone.org/ -C #{@root_dir}/src/ -a #{@options[:arch]} --after-install #{@root_dir}/bash_scripts/after-install.sh --after-remove #{@root_dir}/bash_scripts/after-remove.sh`
    pp command
    package = command.match(/rclone.*#{@options[:version]}-#{@options[:iteration]}.*rpm/).to_s

    push_package(@packagecloud_config[:packagecloud_repository], "#{@root_dir}/#{package}", @options[:dists])
  end

  desc "Download and unzip files"
  task :download => [:check, :init] do
    download_file("https://github.com/ncw/rclone/releases/download/v#{@options[:version]}/rclone-v#{@options[:version]}-#{@options[:os]}-#{@options[:arch]}.zip", @options[:sha256])
    FileUtils.cp("#{@root_dir}/tmp_files/rclone-v#{@options[:version]}-#{@options[:os]}-#{@options[:arch]}/rclone", "#{@root_dir}/src/usr/bin/rclone")
    FileUtils.cp("#{@root_dir}/tmp_files/rclone-v#{@options[:version]}-#{@options[:os]}-#{@options[:arch]}/rclone.1", "#{@root_dir}/src/usr/local/share/man/man1/rclone.1")
  end

  desc "Create src directories"
  task :init do
    FileUtils.mkdir_p "#{@root_dir}/src/usr/bin"
    FileUtils.mkdir_p "#{@root_dir}/src/usr/local/share/man/man1"
    FileUtils.mkdir_p "#{@root_dir}/tmp_files"
  end

  desc "Cleanup build files"
  task :clean do
    FileUtils.rm_r Dir.glob("#{@root_dir}/src/*"), force: true, secure: true
    FileUtils.rm_r Dir.glob("#{@root_dir}/tmp_files/*"), force: true, secure: true
    FileUtils.rm_r Dir.glob("#{@root_dir}/*.deb"), force: true, secure: true
    FileUtils.rm_r Dir.glob("#{@root_dir}/*.rpm"), force: true, secure: true
  end

  desc "Setup and configuration checks"
  task :check do
    #Check if dependancies are met and config is set
    check_ruby_version
    check_required_gems
    check_required_config
    check_repository
    build_options
  end

end
