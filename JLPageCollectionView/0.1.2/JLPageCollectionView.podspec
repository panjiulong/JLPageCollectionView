#
# Be sure to run `pod lib lint JLPageCollectionView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JLPageCollectionView'
  s.version          = '0.1.2'
  s.summary          = 'JLPageCollectionView is a control that simulates WeChat emoticon keyboard'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
JLPageCollectionView is a control that simulates WeChat emoticon keyboard. It has a control with collectionView, supports linkage scrolling, supports user-defined interface, controls collectionview data, scrolling linkage, etc.
                       DESC

  s.homepage         = 'https://github.com/panjiulong/JLPageCollectionView'
 #s.screenshots     = 'https://github.com/panjiulong/JLPageCollectionView/blob/master/PEexg4zZch.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'panjiulong' => 'jiulongpan@gmail.com' }
  s.source           = { :git => 'https://github.com/panjiulong/JLPageCollectionView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://www.jianshu.com/u/a8601fa19a75'

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'
  s.source_files = 'JLPageCollectionView/Classes/**/*'
  s.social_media_url   = 'https://github.com/panjiulong' # 个人主页
  
  # s.resource_bundles = {
  #   'JLPageCollectionView' => ['JLPageCollectionView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
