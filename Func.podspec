
Pod::Spec.new do |s|
	s.name 		= 'Func'
	s.version 	= '1.1.0'
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
		cs.source_files = 'source/*.swift', 'source/Classes/[A, D, J, M, R, T]*.swift', 'source/Extensions/*.swift'
	end
	
	s.subspec 'Views' do |vs|
		vs.frameworks 	= 'WebKit'
		vs.source_files	= 'source/Views/*.swift', 'source/Dialogs/*.swift', 'source/Classes/KeyboardControl.swift'
		vs.resources = 'source/Assets/KeyboardControl/*'
		vs.dependency 'Func/Core'
		vs.dependency 'SnapKit', '~> 3.0'
	end
	
	s.subspec 'Geocoding' do |gs|
		gs.source_files = 'source/Geocoding/*.swift'
		gs.dependency 'Gloss', '~> 1.0'
		gs.dependency 'Alamofire', '~> 4.0'
	end
	
	s.subspec 'API' do |as|
		as.source_files = 'source/API/*.swift'
		as.dependency 'Func/Core'
		as.dependency 'Alamofire', '~> 4.0'
	end

	s.subspec 'JSON' do |js|
		js.source_files = 'source/FuncJSON/*.swift'
		js.dependency 'Func/Core'
	end
end
