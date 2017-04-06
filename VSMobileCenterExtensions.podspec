Pod::Spec.new do |s|
  s.name         = 'VSMobileCenterExtensions'
  s.version      = `cat version.txt`.chomp
  s.license      = { :type => 'MIT' } 
  s.homepage     = 'https://github.com/xamarinhq/test-cloud-xcuitest-extensions'
  s.authors      = { 'Chris Fuentes' => 'chfuen@microsoft.com' }
  s.summary      = 'Extension library to add value to XCUITests run in Xamarin Test Cloud/Visual Studio Mobile Center'
  s.source       = { :git => 'https://github.com/xamarinhq/test-cloud-xcuitest-extensions.git'  }
  s.source_files = 'VSMobileCenterExtensions/*.{h,m}'
  s.ios.framework    = 'XCTest'
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
end
