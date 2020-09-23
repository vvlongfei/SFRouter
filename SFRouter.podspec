#
# Be sure to run `pod lib lint SFRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFRouter'
  s.version          = '0.1.0'
  s.summary          = 'SFRouter 是一个iOS oc 的路由方案，简单易用'

  s.description      = <<-DESC
      ios objective-c 路由，可以通过url、native两种调用方案，包含页面跳转、功能调用等，该路由方案有有借鉴与LJRouter方案。
                       DESC

  s.homepage         = 'https://github.com/vvlongfei/SFRouter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'longfei' => 'vvlongfei@163.com' }
  s.source           = { :git => 'https://github.com/vvlongfei/SFRouter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SFRouter/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SFRouter' => ['SFRouter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'YYModel'
end
