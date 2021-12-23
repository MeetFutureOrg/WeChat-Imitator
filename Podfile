platform :ios, '13.0'

# ignore all warnings from all pods
inhibit_all_warnings!

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

# ignore spec repo warning
install! 'cocoapods', :warn_for_unused_master_specs_repo => false

def rx_swift
  pod 'RxSwift', '~> 6.2'
end

def rx_cocoa
  pod 'RxCocoa'
end

def rx_data_sources
  pod 'RxDataSources'
end

def rx_gesture
  pod 'RxGesture'
end

def rx_keyboard
  pod 'RxKeyboard'
end

def rx_swift_ext
  pod 'RxSwiftExt'
end

def rx_optional
  pod 'RxOptional'
end

def alamofire
  pod 'Alamofire'
end

def moya
  pod 'Moya/RxSwift'
end

def kingfisher
  pod 'Kingfisher'
end

def texture
  pod 'Texture'
end

def snap_kit
  pod 'SnapKit'
end

def navigation_bar
  pod 'HBDNavigationBar'
end

def text_view
  pod 'NextGrowingTextView'
end

def image_viewer
  pod 'ImageViewer'
end

def image_picker
  pod 'YPImagePicker'
end

def swipe_cell
  pod 'SwipeCellKit'
end

def eureka
  pod 'Eureka'
end

def mmkv
  pod 'MMKV'
end

def wcdb
  pod 'WCDB.swift'
end

def zip
  pod 'SSZipArchive'
end

def diff
  pod 'DeepDiff'
end

def date
  pod 'SwiftDate'
end

def device
  pod 'DeviceKit'
end

def object_mapper
  pod 'ObjectMapper'
end

def user_defaults
  pod 'SwiftyUserDefaults'
end

def reachability
  pod 'ReachabilitySwift'
end

def swifter
  pod 'SwifterSwift'
end


def lint
  pod 'SwiftLint'
end

def debugging_tools()
  pod 'matrix-wechat'
  pod 'FLEX', :configurations => ['Debug']
  pod 'Wormholy', :configurations => ['Debug']
end

def rx_components()
  rx_swift
  rx_swift_ext
  rx_optional
end

target 'WeChat' do
  # Pods for WeChatmo
  rx_components()
  rx_cocoa
  rx_data_sources
  rx_keyboard
  rx_gesture
  
  texture
  snap_kit
  swipe_cell
  text_view
  image_viewer
  image_picker
  navigation_bar
  eureka
  
  alamofire
  reachability
  moya
  kingfisher
  object_mapper
  
  diff
  
  user_defaults
  mmkv
  wcdb
  zip
  
  date
  device
  swifter
  
  debugging_tools()
  lint
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
