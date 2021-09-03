#
# Be sure to run `pod lib lint XJHNetworkInterceptorKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XJHNetworkInterceptorKit'
  s.version          = '0.1.6'
  s.summary          = 'XJHNetworkInterceptorKit is a Kit of URLSession Interceptor.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'XJHNetworkInterceptorKit is a Kit of URLSession Interceptor.@XJHNetworkInterceptorKit'

  s.homepage         = 'https://github.com/cocoadogs/XJHNetworkInterceptorKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cocoadogs' => 'cocoadogs@163.com' }
  s.source           = { :git => 'https://github.com/cocoadogs/XJHNetworkInterceptorKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  
  s.public_header_files = 'XJHNetworkInterceptorKit/XJHNetworkInterceptorKit.h'
  s.source_files = 'XJHNetworkInterceptorKit/XJHNetworkInterceptorKit.h'
  
  s.subspec 'Manager' do |ss|
    ss.public_header_files = 'XJHNetworkInterceptorKit/XJHNetFlowManager.h'
    ss.source_files = 'XJHNetworkInterceptorKit/XJHNetFlowManager.{h,m}','XJHNetworkInterceptorKit/XJHURLProtocol.{h,m}','XJHNetworkInterceptorKit/XJHNetworkInterceptor.{h,m}','XJHNetworkInterceptorKit/NSURLSessionConfiguration+XJH.{h,M}'
    ss.dependency 'XJHNetworkInterceptorKit/DataSource'
    ss.dependency 'XJHNetworkInterceptorKit/Demux'
    ss.dependency 'XJHNetworkInterceptorKit/Model'
    ss.dependency 'XJHNetworkInterceptorKit/Util'
  end
  
  s.subspec 'DataSource' do |ss|
    ss.public_header_files = 'XJHNetworkInterceptorKit/XJHNetFlowDataSource.h'
    ss.source_files = 'XJHNetworkInterceptorKit/XJHNetFlowDataSource.{h,m}'
    ss.dependency 'XJHNetworkInterceptorKit/Model'
  end
  
  
  s.subspec 'Controller' do |ss|
    ss.public_header_files = 'XJHNetworkInterceptorKit/XJHRequestResponseViewController.h','XJHNetworkInterceptorKit/XJHRequestResponseDetailViewController.h'
    ss.source_files = 'XJHNetworkInterceptorKit/XJHRequestResponseViewController.{h,m}','XJHNetworkInterceptorKit/XJHRequestResponseSearchViewController.{h,m}','XJHNetworkInterceptorKit/XJHRequestResponseDetailViewController.{h,m}'
    ss.dependency 'XJHNetworkInterceptorKit/Cell'
    ss.dependency 'XJHNetworkInterceptorKit/View'
    ss.dependency 'XJHNetworkInterceptorKit/ViewModel'
    ss.dependency 'XJHNetworkInterceptorKit/Manager'
  end
  
  s.subspec 'Cell' do |ss|
    ss.public_header_files = 'XJHNetworkInterceptorKit/XJHNetworkInterceptorViewCell.h','XJHNetworkInterceptorKit/XJHNetFlowDetailViewCell.h'
    ss.source_files = 'XJHNetworkInterceptorKit/XJHNetworkInterceptorViewCell.{h,m}','XJHNetworkInterceptorKit/XJHNetFlowDetailViewCell.{h,m}'
    ss.dependency 'XJHNetworkInterceptorKit/ViewModel'
    ss.dependency 'YYText'
  end
  
  s.subspec 'View' do |ss|
    ss.public_header_files = 'XJHNetworkInterceptorKit/XJHNetFlowDetailSegment.h'
    ss.source_files = 'XJHNetworkInterceptorKit/XJHNetFlowDetailSegment.{h,m}'
  end
  
  s.subspec 'ViewModel' do |ss|
    ss.public_header_files = 'XJHNetworkInterceptorKit/XJHRequestResponseViewModel.h','XJHNetworkInterceptorKit/XJHRequestResponseItemViewModel.h'
    ss.source_files = 'XJHNetworkInterceptorKit/XJHRequestResponseViewModel.{h,m}','XJHNetworkInterceptorKit/XJHRequestResponseItemViewModel.{h,m}'
    ss.dependency 'XJHNetworkInterceptorKit/Model'
    ss.dependency 'XJHNetworkInterceptorKit/DataSource'
  end
  
  s.subspec 'Demux' do |ss|
    ss.public_header_files = 'XJHNetworkInterceptorKit/XJHURLSessionDemux.h'
    ss.source_files = 'XJHNetworkInterceptorKit/XJHURLSessionDemux.{h,m}'
  end
  
  s.subspec 'Model' do |ss|
    ss.public_header_files = 'XJHNetworkInterceptorKit/XJHNetFlowHttpModel.h'
    ss.source_files = 'XJHNetworkInterceptorKit/XJHNetFlowHttpModel.{h,m}'
    ss.dependency 'XJHNetworkInterceptorKit/Util'
  end
  
  s.subspec 'Util' do |ss|
    ss.public_header_files = 'XJHNetworkInterceptorKit/XJHUrlUtil.h','XJHNetworkInterceptorKit/NSObject+XJHSwizzle.h','XJHNetworkInterceptorKit/NSURLRequest+XJH.h'
    ss.source_files = 'XJHNetworkInterceptorKit/XJHUrlUtil.{h,m}','XJHNetworkInterceptorKit/NSObject+XJHSwizzle.{h,m}','XJHNetworkInterceptorKit/NSURLRequest+XJH.{h,m}'
  end
  
  s.dependency 'ReactiveObjC', '>= 3.1.1'
  
  # s.resource_bundles = {
  #   'XJHNetworkInterceptorKit' => ['XJHNetworkInterceptorKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
