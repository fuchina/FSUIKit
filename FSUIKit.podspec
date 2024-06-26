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

  s.ios.deployment_target = '12.0'
  s.source_files = 'FSUIKit/Classes/*'

  #s.dependency   'FSWindow'
  s.dependency   'MJRefresh','3.2.3'
  s.dependency   'FSCalculator'
  
  s.frameworks = 'UIKit'

end
