# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'SmartSight' do
  use_frameworks!

  # Pods for SmartSight
pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
pod 'SnapKit', '~> 4.0'


end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end

