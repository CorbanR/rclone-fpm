require 'yaml'

def packagecloud_config
  packagecloud_api_key = ENV["PACKAGECLOUD_API_KEY"]
  packagecloud_username = ENV["PACKAGECLOUD_USERNAME"]
  packagecloud_repository = ENV["PACKAGECLOUD_REPOSITORY"]

  configuration_file = "#{ENV["HOME"]}/.packagecloud-ruby"
  if File.file?(configuration_file)
    config = YAML.load_file(configuration_file)
    packagecloud_api_key ||= config["PACKAGECLOUD_API_KEY"]
    packagecloud_username ||= config["PACKAGECLOUD_USERNAME"]
    packagecloud_repository ||= config["PACKAGECLOUD_REPOSITORY"]
  end

  @packagecloud_config = {
    packagecloud_api_key: packagecloud_api_key,
    packagecloud_username: packagecloud_username,
    packagecloud_repository: packagecloud_repository,
  }
end

def build_options
  version = ENV["version"]
  os = ENV["os"]
  arch = ENV["arch"]
  sha256 = ENV["sha256"]
  iteration = ENV["iteration"]
  dists = ENV["dists"].split(",")

  @options = {
    version: version,
    os: os,
    arch: arch,
    sha256: sha256,
    iteration: iteration,
    dists: dists,
  }
end
