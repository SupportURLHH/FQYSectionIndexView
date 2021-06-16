Pod::Spec.new do |spec|
  spec.name         = "SectionIndexView"
  spec.version      = "0.0.1"
  spec.summary      = "A custom tableView sectionIndex View"
  spec.homepage     = "https://github.com/SupportURLHH/SectionIndexView.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "fqy" => "489863961@qq.com" }
  
  spec.platform     = :ios
  spec.platform     = :ios, "5.0"


  spec.source       = { :git => "https://github.com/SupportURLHH/SectionIndexView.git", :tag => "#{spec.version}" }

  spec.source_files  = "SectionIndexView/*"
  spec.frameworks = "UIKit", "Foundation"
  spec.requires_arc = true
  spec.swift_version = '5.0'
end
