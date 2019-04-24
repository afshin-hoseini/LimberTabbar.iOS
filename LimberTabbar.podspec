#
# Be sure to run `pod lib lint LimberTabbar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LimberTabbar'
  s.version          = '0.1.0'
  s.summary          = 'Yet another tabbar with smooth animation.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/afshin-hoseini/LimberTabbar.iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'afshin.hoseini@gmail.com' => 'afshin.hoseini@gmail.com' }
  s.source           = { :git => 'https://github.com/afshin.hoseini@gmail.com/LimberTabbar.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/hoseini_afshin'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LimberTabbar/**/*.swift'
  
  # s.resource_bundles = {
  #   'LimberTabbar' => ['LimberTabbar/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
