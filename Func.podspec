
Pod::Spec.new do |s|
	s.name 		= 'Func'
	s.version 	= '1.2.8'
	s.author 	= { 'Arbitur' => 'arbiturr@gmail.com' }
	s.license 	= { :type => 'MIT', :file => 'LICENSE' }
	s.homepage 	= 'https://github.com/arbitur/Func'
	s.source 	= { :git => 'https://github.com/arbitur/Func.git', :tag => s.version, :branch => 'master' }
	s.summary 	= 'Collection of extensions and helper classes'
	
	s.platform 	= :ios, '10.0'
	
	s.module_name 	= 'Func'
	s.default_subspec = 'Core'

	s.subspec 'Core' do |cs|
		cs.frameworks 	= 'UIKit', 'CoreLocation'
		cs.source_files = 'source/*.swift', 'source/Core/**/*.swift'
	end
	
	s.subspec 'UI' do |vs|
		vs.frameworks 	= 'WebKit'
		vs.source_files	= 'source/UI/**/*.swift'
		vs.resources = 'source/Assets/UI/*'
		vs.dependency 'Func/Core'
		vs.dependency 'Func/Constraint'
		#vs.dependency 'SnapKit', '~> 4.0'
	end
	
	s.subspec 'Constraint' do |cs|
		cs.source_files = 'source/Constraint/**/*.swift'
		cs.dependency 'Func/Core'
	end
	
	s.subspec 'API' do |as|
		as.source_files = 'source/API/**/*.swift'
		as.dependency 'Func/Core'
		as.dependency 'Alamofire', '~> 4.0'
	end

	s.subspec 'Decoding' do |js|
		js.source_files = 'source/Decoding/**/*.swift'
		js.dependency 'Func/Core'
	end
	
	s.subspec 'Geocoding' do |gs|
		gs.source_files = 'source/Geocoding/**/*.swift'
		gs.dependency 'Func/API'
		gs.dependency 'Func/Decoding'
	end
end
