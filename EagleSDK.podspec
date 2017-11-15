#
# Be sure to run `pod lib lint EagleSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EagleSDK'
  s.version          = '0.0.1'
  s.summary          = 'EagleSDK of Linkstec.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is Linkstec's Product.
                       DESC

  s.homepage         = 'https://www.linkstec.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'linkstec@linkstec.com' => 'linkstec@linkstec.com' }
  s.source           = { :git => 'ssh://git@192.168.2.94:10022/project/ios/eagle-base.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'EagleSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'EagleSDK' => ['EagleSDK/Assets/*.png']
  # }

  s.public_header_files = 'EagleSDK/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 3.1'
  s.dependency 'SSZipArchive'
  s.dependency 'Masonry', '~> 1.1.0'
end
