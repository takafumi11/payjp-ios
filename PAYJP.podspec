#
# Be sure to run `pod lib lint PAYJP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PAYJP'
  s.version          = '1.1.1'
  s.summary          = 'PAY.JP iOS SDK'
  s.description      = 'PAY.JP iOS SDK https://pay.jp/docs/started'

  s.homepage         = 'https://github.com/payjp/payjp-ios'
  s.license          = { :type => 'MIT' }
  s.author           = { 'PAY.JP (https://pay.jp)' => 'support@pay.jp' }
  s.source           = { :git => 'https://github.com/payjp/payjp-ios.git', :tag => s.version.to_s, submodules: true }
  s.swift_version    = '5.0'

  s.ios.deployment_target = '9.0'

  s.source_files = ['Sources/**/*.{h,m,swift,xib,strings,storyboard}']
  s.public_header_files = 'Sources/**/*.h'
  s.frameworks = 'PassKit'
  s.resource_bundles = { 'PAYJP' => 'Assets.xcassets' }
  
end
