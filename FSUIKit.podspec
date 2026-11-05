Pod::Spec.new do |s|
  s.name             = 'FSUIKit'
  s.version          = '0.0.9'
  s.summary          = 'FSUIKit is a tool for show logs when app run'
  s.description      = <<-DESC
		This is a very small software library, offering a few methods to help with programming.
    DESC

  s.homepage         = 'https://github.com/fuchina/FSUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fudon' => '1245102331@qq.com' }
  s.source           = { :git => 'https://github.com/fuchina/FSUIKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '18.0'
  s.source_files = 'FSUIKit/Classes/**/*'
  
#  s.module_name = 'FSUIKit'

  s.frameworks = 'UIKit'
  
  s.swift_version = '6'

  # 2026-11-05 去除死依赖：MJRefresh / WechatOpenSDK 在 FSUIKit 的 15 个 Swift 文件里
  # 零 import、零使用（仅 FSShare.swift 里留有整段被注释掉的 WXApi 示例代码）。
  # 二者一直由本 podspec 的 s.dependency 带进主工程 Pods，却从未被任何代码引用，
  # 去掉后 Pods 目录可少两个 target 及其 xcconfig 搜索路径。
  #
  # 注意：FSShare 的微信分享当前是「未实现」状态（见 FSShare.swift 顶部说明）。
  # 将来真要接微信 SDK，应在届时重新加回 dependency 并配上 bridging header，
  # 而不是依赖本文件的历史残留。
  s.dependency   'FSKit'
  
#  s.dependency   'FSCalculator'

end
