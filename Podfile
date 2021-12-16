platform :ios, '13.0'

# ignore all warnings from all pods
inhibit_all_warnings!

# Comment the next line if you don't want to use dynamic frameworks
use_frameworks!

# ignore spec repo warning
install! 'cocoapods', :warn_for_unused_master_specs_repo => false

def rx_swift
  pod 'RxSwift', '~> 6.0'
end

def rx_cocoa
  pod 'RxCocoa', '~> 6.0'
end

def rx_data_sources
  pod 'RxDataSources', '~> 5.0'
end

def rx_keyboard
  pod 'RxKeyboard', '~> 2.0'
end

def rx_swift_ext
  pod 'RxSwiftExt', '~> 6.0'
end

def rx_optional
  pod 'RxOptional', '~> 5.0'
end

def moya
  pod 'Moya/RxSwift', '~> 15.0'
end

def texture
  pod 'Texture', '~> 3.0'
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

def eureka()
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
  debugging_tools()
  
  lint
end

target 'ChatSession' do
  # Pods for ChatSession
  rx_components()
  rx_cocoa
  rx_data_sources
  texture
  diff
  snap_kit
  swipe_cell
  swifter

  lint
end

target 'ChatRoom' do
  # Pods for ChatRoom
  rx_components()
  rx_cocoa
  rx_data_sources
  texture
  diff
  snap_kit
  rx_keyboard
  text_view
  image_viewer
  image_picker
  swifter

  lint
end

target 'Contact' do
  # Pods for Contact
  rx_components()
  rx_cocoa
  rx_data_sources
  texture
  diff
  snap_kit
  
  lint
end

target 'Discovery' do
  # Pods for Discovery
  rx_components()
  rx_cocoa
  rx_data_sources
  texture
  diff
  snap_kit
  
  lint
end

target 'Profile' do
  # Pods for Profile
  rx_components()
  rx_cocoa
  rx_data_sources
  texture
  diff
  snap_kit
  eureka()
  
  lint
end

target 'Account' do
  # Pods for Account
  rx_components()
  
  lint
end

target 'Context' do
  # Pods for Context
  rx_components()
  
  lint
end

target 'Component' do
  # Pods for Component
  rx_components()
  rx_cocoa
  rx_data_sources
  texture
  diff
  snap_kit
  
  lint
end

target 'Search' do
  # Pods for Search
  rx_components()
  rx_cocoa
  rx_data_sources
  texture
  diff
  snap_kit
  
  lint
end

target 'Model' do
  # Pods for Model
  rx_components()
  moya
  object_mapper
  
  lint
end

target 'Common' do
  # Pods for Common
  rx_components()
  rx_cocoa
  texture()
  navigation_bar
  
  lint
end

target 'Utilities' do
  # Pods for Utilities
  rx_components()
  user_defaults
  zip
  date
  device
  
  lint
end

target 'Networking' do
  # Pods for Networking
  rx_components()
  rx_cocoa
  reachability
  moya
  
  lint
end

target 'Database' do
  # Pods for Database
  rx_components()
  mmkv
  wcdb
  
  lint
end

target 'Emoticon' do
  # Pods for Emoticon
  rx_components()
  rx_cocoa
  
  lint
end

target 'Logger' do
  # Pods for Logger
  rx_components()
  
  lint
end

target 'Resource' do
  # Pods for Resource
  rx_components()
  
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
