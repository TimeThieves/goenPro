# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GOEN' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for GOEN
  pod "Alamofire"
  pod "SwiftyJSON",'3.1.4'
  pod 'SVProgressHUD'
  pod 'Cloudinary', '~> 2.0'
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
  
  target 'GOENTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GOENUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
