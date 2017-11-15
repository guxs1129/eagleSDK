Pod::Spec.new do |s|
  s.name = "TestFrameWork"
  s.version = "0.1.0"
  s.summary = "A short description of TestFrameWork."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"guxs1129@163.com"=>"guxs@linkstec.com"}
  s.homepage = "https://github.com/guxs1129@163.com/TestFrameWork"
  s.description = "TODO: Add long description of the pod here."
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/TestFrameWork.framework'
end
