Pod::Spec.new do |s|
  s.name         = 'FoldingCell'
  s.version      = '0.8.6'
  s.summary      = 'UITableViewCell with folding animation.'
  s.homepage     = 'https://github.com/Ramotion/folding-cell'
  s.license      = 'MIT'
  s.authors = { 'Juri Vasylenko' => 'juri.v@ramotion.com' }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/Ramotion/folding-cell.git', :tag => s.version.to_s }
  s.source_files  = 'FoldingCell/FoldingCell/FoldingCell/*.swift'
  s.requires_arc = true
end
