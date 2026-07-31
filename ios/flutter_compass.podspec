#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_compass'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter compass. The heading varies from 0-360, 0 being north.'
  s.description      = <<-DESC
A Flutter compass. The heading varies from 0-360, 0 being north.
                       DESC
  s.homepage         = 'https://github.com/hemanthrajv/flutter_compass'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_compass/Sources/flutter_compass/**/*.swift'
  s.dependency 'Flutter'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
