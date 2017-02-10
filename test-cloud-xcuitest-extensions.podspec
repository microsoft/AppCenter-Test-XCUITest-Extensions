Pod::Spec.new do |s|
  s.name         = 'test-cloud-xcuitest-extensions'
  s.version      = '0.0.1'
  s.license      = { :type => 'MIT' } 
  s.homepage     = 'https://github.com/xamarinhq/test-cloud-xcuitest-extensions'
  s.authors      = { 'Chris Fuentes' => 'chfuen@microsoft.com' }
  s.summary      = 'Extension library to add value to XCUITests run in TestCloud/MobileCenter device cloud'
  s.source       = { :git => 'https://github.com/xamarinhq/test-cloud-xcuitest-extensions.git', :tag => '0.0.1' }
  s.source_files = 'XCUITestExtensions/*.{h,m}'
  s.ios.framework    = 'XCTest'
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
end
