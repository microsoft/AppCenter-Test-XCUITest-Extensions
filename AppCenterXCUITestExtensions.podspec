Pod::Spec.new do |s|

  version = `cat version.txt`.chomp

  s.name         = 'AppCenterXCUITestExtensions'
  s.version      = version
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/xamarinhq/test-cloud-xcuitest-extensions'
  s.authors      = { 'Chris Fuentes' => 'chfuen@microsoft.com',
                     'Joshua Moody' => 'josmoo@microsoft.com' }
  s.summary      = %Q[

AppCenter XCUITest Extensions is an iOS Framework for taking screenshots
and labeling test steps when running XCUITest test in App Center or
Xamarin Test Cloud. At the conclusion of each test method, a label and
screenshot are automatically generated for the test report. You can
create additional labels and screenshots to track your app's progress
during a test method.

This framework is _required_ for running XCUITests in App Center and
Xamarin Test Cloud.

],
  s.source       = { git: 'https://github.com/xamarinhq/appcenter-test-cloud-xcuitest-extensions.git',
                     tag: version }
  s.ios.source_files = 'AppCenterXCUITestExtensions/*.{h,m}'
  s.ios.public_header_files = "AppCenterXCUITestExtensions/**/*.h"
  s.ios.framework = 'XCTest'
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
end
