#
# Be sure to run `pod lib lint PayJP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PAYJP'
  s.version          = '0.1.3'
  s.summary          = 'PAY.JP iOS SDK'
  s.description      = 'PAY.JP iOS SDK'

  s.homepage         = 'https://github.com/payjp/payjp-ios'
  s.license          = { :type => 'MIT' }
  s.author           = { 'PAY.JP (https://pay.jp)' => 'support@pay.jp' }
  s.source           = { :git => 'https://github.com/payjp/payjp-ios.git', :tag => s.version.to_s, submodules: true }

  s.ios.deployment_target = '8.0'
  s.xcconfig = {
    'SWIFT_VERSION' => '3.0'
  }

  s.source_files = ['Sources/**/*', 
                    'Carthage/Checkouts/Himotoki/Sources/**/*.swift', 
                    'Carthage/Checkouts/Result/Result/**/*.swift']
  s.public_header_files = 'Sources/**/*.h'
  s.frameworks = 'PassKit'
end
