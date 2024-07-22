# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Basic' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'RxSwift',    '~> 5'
  pod 'RxCocoa',    '~> 5'
  pod 'RxFlow'
  pod 'RxOptional'
  pod 'RxSwiftExt'
  pod 'NSObject+Rx'
  pod 'RxDataSources'
  pod 'Cell+Rx'
  pod 'Action'

  pod 'Then'
  pod 'SnapKit'
  pod 'Reusable'
#  pod 'SwiftLint'
  pod 'KeychainSwift'
  
  # Image
  pod 'SDWebImage', '~> 5.0'
#  pod 'lottie-ios'
  pod 'Kingfisher', '~> 5.0'

  # Network
  pod 'Moya/RxSwift',   '~> 14.0'
  pod 'SwiftyJSON'

  # Pods for Basic

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
end