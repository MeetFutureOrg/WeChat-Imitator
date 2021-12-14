platform :ios, '13.0'

# ignore all warnings from all pods
inhibit_all_warnings!

# ignore spec repo warning
install! 'cocoapods', :warn_for_unused_master_specs_repo => false

def rx_components()
  pod 'RxCocoa', '~> 6.0'
  pod 'Moya/RxSwift', '~> 15.0'
  pod 'RxDataSources', '~> 5.0'
  pod 'RxKeyboard', '~> 2.0'
  pod 'RxSwiftExt', '~> 6.0'
  pod 'RxOptional'
end

def ui_components()
  pod 'Texture'
  pod 'SnapKit'
  pod 'HBDNavigationBar'
  pod 'NextGrowingTextView'
  pod 'ImageViewer'
  pod 'YPImagePicker'
  pod 'SwipeCellKit'
  pod 'Eureka'
end

def data_persistence()
  pod 'MMKV'
  pod 'WCDB.swift'
  pod 'SSZipArchive'
end

def utilities()
  pod 'DeepDiff'
  pod 'SwiftDate'
  pod 'DeviceKit'
  pod 'ObjectMapper'
  pod 'SwiftyUserDefaults'
  pod 'ReachabilitySwift'
  pod 'SwiftLint'
end

def debugging_tools()
  pod 'matrix-wechat'
  pod 'FLEX', :configurations => ['Debug']
  pod 'Wormholy', :configurations => ['Debug']
end

target 'WeChat' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WeChatmo
  rx_components()
  ui_components()
  data_persistence()
  utilities()
  debugging_tools()

end

# Deployment Target Version
post_install do |installer|
  # rmeove AssetsLibrary framework
  installer.pods_project.frameworks_group["iOS"]["AssetsLibrary.framework"].remove_from_project
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      if target.name == 'WCDB.swift'
        config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
        config.build_settings['SWIFT_VERSION'] = "5.0"
      end
    end
  end
end
