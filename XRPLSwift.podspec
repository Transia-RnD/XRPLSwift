#
# Be sure to run `pod lib lint XRPLSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XRPLSwift'
  s.version          = '0.9.9-beta.1'
  s.summary          = 'A Swift API for interacting with the XRP Ledger.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'XRPLSwift is a Swift SDK built for interacting with the XRP Ledger.  XRPLSwift supports offline wallet creation, offline transaction creation/signing, and submitting transactions to the XRP ledger.  XRPLSwift supports both the secp256k1 and ed25519 algorithms. XRPLSwift is available on iOS, macOS and Linux (SPM)'

  s.homepage         = 'https://github.com/Transia-RnD/XRPLSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'ISC', :file => 'LICENSE' }
  s.author           = { 'Transia-RnD' => 'dangell@transia.co' }
  s.source           = { :git => 'https://github.com/Transia-RnD/XRPLSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = "12.0"
  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'
  s.swift_version = '5.1.1'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.1.1' }

  s.source_files = 'Sources/XRPLSwift/**/*'
#  s.resources = 'XRPLSwift/Assets/*.xcassets'
  # s.resource_bundles = {
  #   'XRPLSwift' => ['XRPLSwift/Assets/*.png']
  # }

  s.dependency 'secp256k1.swift'
  s.dependency 'CryptoSwift', '~> 1.5.1'
  s.dependency 'BigInt', '~> 5.0'
  s.dependency 'AnyCodable-FlightSchool'
  s.dependency 'SwiftNIO'
  
  s.static_framework = true

end
