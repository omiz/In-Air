source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

platform :ios, '9.0'

#https://github.com/delba/TextAttributes
pod 'TextAttributes'

#https://github.com/tristanhimmelman/AlamofireObjectMapper
pod 'AlamofireObjectMapper', '~> 4.0'

#https://github.com/onevcat/Kingfisher
pod 'Kingfisher', '~> 3.0'

target 'In Air' do
end

post_install do |installer|
   installer.pods_project.targets.each do |target|
      version_value = '3.0'
      target.build_configurations.each do |config|
         config.build_settings['SWIFT_VERSION'] = version_value
      end
   end
end
