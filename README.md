# rclone-fpm
Easily build and push rclone deb and rpm packages to packagecloud

## Requirements
* See [fpm](http://fpm.readthedocs.io/en/latest/installing.html) requirements for your OS.
* Ruby >= 2.3

## Setup
* `gem install bundler && bundle install`

## Packagecloud
The gem used in these `rake` tasks is [packagecloud-ruby](https://github.com/computology/packagecloud-ruby). 
After ensuring system requirements and setup, you will need a packagecloud API token. 
Login to [packagecloud.io](https://packagecloud.io/), click on the API Token button under Home to see your API token.

#### Configuration
For convenience of the `rake` tasks you can set the following environment variables.  
`PACKAGECLOUD_API_KEY=<packagecloud_api_key>`  
`PACKAGECLOUD_USERNAME=<username>`  
`PACKAGECLOUD_REPOSITORY: <packagecloud_repository>`
  
Alternatively create `~/.packagecloud-ruby` with...  
  ```
    PACKAGECLOUD_API_KEY: <packagecloud_api_key>
    PACKAGECLOUD_USERNAME: <username>
    PACKAGECLOUD_REPOSITORY: <packagecloud_repository>
  ```

**NOTE:** Environment variables take precedence.

## Usage
DEB Example:   
`rake build:deb version=1.40 os=linux iteration=1 arch=amd64 sha256=a11022c2d7bd0b2a641b98011e587c04e21589c6059e9581721c0cbf5d8fe178 dists=ubuntu/trusty,ubuntu/xenial`

RPM Example:
`rake build:rpm version=1.40 os=linux iteration=1 arch=amd64 sha256=a11022c2d7bd0b2a641b98011e587c04e21589c6059e9581721c0cbf5d8fe178 dists=el/5,el/6,el/7`
