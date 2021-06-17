Pod::Spec.new do |spec|
  spec.name         = "FQYSectionIndexView"
  spec.version      = "0.0.3"
  spec.summary      = "A custom tableView sectionIndex View"
  spec.homepage     = "https://github.com/SupportURLHH/FQYSectionIndexView.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "fqy" => "489863961@qq.com" }
  
  spec.platform     = :ios, "9.0"


  spec.source       = { :git => "https://github.com/SupportURLHH/FQYSectionIndexView.git", :tag => "#{spec.version}" }

  spec.source_files  = "Source/**/*"
  spec.frameworks = "UIKit", "Foundation"
  spec.requires_arc = true
  spec.swift_version = '5.0'
end
