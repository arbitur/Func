
Pod::Spec.new do |s|
	s.name 		= 'Func'
	s.version 	= '1.0.2'
	s.author 	= { 'Arbitur' => 'arbiturr@gmail.com' }
	s.license 	= { :type => 'MIT', :file => 'LICENSE' }
	s.homepage 	= 'https://github.com/arbitur/Func'
	s.source 	= { :git => 'https://github.com/arbitur/Func.git', :tag => s.version, :branch => 'master' }
	s.summary 	= 'Collection of extensions and helper classes'
	
	s.platform 	= :ios, '9.0'
	
	s.module_name 	= 'Func'
	s.default_subspec = 'Core'
	
	s.subspec 'Core' do |cs|
		cs.frameworks 	= 'UIKit', 'CoreLocation'
		cs.source_files = 'source/*.swift', 'source/Classes/*.swift', 'source/Extensions/*.swift'
		cs.resources 	= 'source/Assets/KeyboardControl/*'
	end
	
	s.subspec 'Views' do |vs|
		vs.frameworks 	= 'WebKit'
		vs.source_files	= 'source/Views/*.swift', 'source/Dialogs/*.swift', 'source/Animation/*.swift'
		vs.dependency 'Func/Core'
		vs.dependency 'SnapKit', '~> 3.0'
	end
	
	s.subspec 'Geocoding' do |gs|
		gs.source_files = 'source/Geocoding/*.swift'
		gs.dependency 'Gloss', '~> 1.0'
		gs.dependency 'Alamofire', '~> 4.3.0'
	end
end
