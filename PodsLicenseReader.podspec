
Pod::Spec.new do |s|
  s.name          = "PodsLicenseReader"
  s.version       = "0.0.3"
  s.summary       = "Easily read licenses for your Cocoa Pods."
  s.homepage      = "https://github.com/comyarzaheri/PodsLicenseReader"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "Comyar Zaheri" => "" }
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.source        = { :git => "https://github.com/comyarzaheri/PodsLicenseReader.git", :tag => s.version.to_s }
  s.source_files  = "PodsLicenseReader/*.{h,swift}", "PodsLicenseReader/**/*.{h,swift}"
  s.module_name   = "PodsLicenseReader"
  s.requires_arc  = true
end
