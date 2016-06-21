source 'https://github.com/CocoaPods/Specs.git'
target 'XYService' do
pod 'AFNetworking', '~> 3.1.0'
pod 'MBProgressHUD', '~> 0.9.1'
end

post_install do |installer|
     puts 'Updating project to 64 Bit'
     installer.pods_project.targets.each do |target|
         target.build_configurations.each do |config|
               config.build_settings['ARCHS'] = "$(ARCHS_STANDARD_INCLUDING_64_BIT)"
         end
     end
end

