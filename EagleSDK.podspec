#
# Be sure to run `pod lib lint EagleSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = 'EagleSDK'
  s.version = '0.0.1'
  s.summary = 'EagleSDK of Linkstec.'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description = <<-DESC
This is Linkstec's Product.
                       DESC

  s.homepage = 'http://www.linkstec.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license = {:type => 'MIT', :file => 'LICENSE'}
  s.author = {'linkstec@linkstec.com' => 'linkstec@linkstec.com'}
  s.source = {:git => 'ssh://git@192.168.2.94:10022/project/ios/eagle-base.git'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  #s.source_files = 'EagleSDK/Classes/**/*'

  # s.resource_bundles = {
  #   'EagleSDK' => ['EagleSDK/Assets/*.png']
  # }

#s.subspec 'Core' do |ss|
#    ss.source_files = 'EagleSDK/Classes/MapKit/*.{h,m}'
#    ss.public_header_files = 'EagleSDK/Classes/MapKit/*.h'
#    ss.frameworks = 'UIKit', 'MapKit'
#    ss.prefix_header_contents = '#import <MapKit/MapKit.h>', '#import <CoreLocation/CoreLocation.h>'
#  end


  #s.public_header_files = 'EagleSDK/Classes/**/*.h', 'EagleSDK/Classes/*.h'
  #s.prefix_header_contents = '#import "EGComponent.h"', '#import "EGDom.h"', '#import "EGMacros.h"', '#import "EGNode.h"', '#import "UIViewController+EGComponent.h"', '#import "EagleSDK.h"', '#import "EGkit.h"', '#import "EGkitManager.h"', '#import "EGButton.h"', '#import "EGController.h"', '#import "EGImageView.h"', '#import "EGLabel.h"', '#import "EGTableView.h"', '#import "EGTextComponent.h"', '#import "EGTrash.h"', '#import "EGView.h"', '#import "EGEvent.h"', '#import "EGEventBus.h"', '#import "EGEventContext.h"', '#import "EGEventExcuter.h"', '#import "NSObject+EventBus.h"', '#import "EGNavigationBarManager.h"', '#import "EGNaviSlideApp.h"', '#import "EGBaseRequest.h"', '#import "EGBatchRequest.h"', '#import "EGBatchRequestAgent.h"', '#import "EGChainRequest.h"', '#import "EGChainRequestAgent.h"', '#import "EGNetwork.h"', '#import "EGNetworkAgent.h"', '#import "EGNetworkConfig.h"', '#import "EGNetworkPrivate.h"', '#import "EGRequest.h"', '#import "EGPopView.h"', '#import "EGRootNavigationController.h"', '#import "UIViewController+EGRootNavigationController.h"', '#import "EGRouter.h"', '#import "EGRouterManager+Blocks.h"', '#import "EGRouterManager.h"', '#import "EGSanboxFile.h"', '#import "EGURLProtocol.h"', '#import "EGWebViewController.h"', '#import "NSObject+WebComponent.h"', '#import "NSURLProtocol+WKWebVIew.h"', '#import "WebComponent.h"', '#import "WebViewJavascriptBridge.h"', '#import "WebViewJavascriptBridgeBase.h"', '#import "WKWebViewJavascriptBridge.h"','#import "EGNaviSlideApp.h"','#import "EGURL.h"', '#import "EGComponentJsonParser.h"', '#import "EGVCJsonBuilderManager.h"', '#import "EGChainKitHeader.h"'
  s.frameworks = 'UIKit', 'MapKit', 'WebKit', 'SystemConfiguration', 'MobileCoreServices'
  s.libraries = 'z'
  s.ios.vendored_frameworks   = ' EagleSDK.framework'
  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'SSZipArchive'
  s.dependency 'Masonry', '~> 1.1.0'
  s.dependency 'MMDrawerController', '~> 0.6.0'
  s.dependency 'ReactiveObjC', '~> 3.0.0'
  s.dependency 'EGIconFont', '0.0.1'
  s.dependency 'TZImagePickerController'
  # s.pod_target_xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '"$PODS_CONFIGURATION_BUILD_DIR/EGIconFont"' }
end
