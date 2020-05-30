
Pod::Spec.new do |spec|
  spec.name         = 'DGItemView'
  spec.version      = '1.0.0'
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.homepage     = 'https://github.com/David5-G/DGItemView'
  spec.authors      = { 'david' => '2632771473@qq.com' }
  spec.summary      = 'a view for segment control'
  spec.source       = { :git => "https://github.com/David5-G/DGItemView.git", :tag => spec.version }
   
  spec.ios.deployment_target  = '8.0'
  spec.source_files  = "DGItemView/*.{h,m}"
  spec.requires_arc = true
  spec.frameworks   = 'UIKit' 

end
