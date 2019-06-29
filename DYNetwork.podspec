Pod::Spec.new do |s|
  s.name             = 'DYNetwork'
  s.version          = '0.3.0'
  s.summary          = 'A short description of DYNetwork.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/SilenceWater/DYNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '昌' => 'dyzhcs' }
  s.source           = { :git => 'https://github.com/SilenceWater/DYNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  
  #s.source_files = 'DYNetwork/Classes/DYNetwork.h'
  s.source_files = 'DYNetwork/Classes/**/*.{h,m}'
  s.public_header_files = 'DYNetwork.h'
  
  
  # 由于request和manager存在互相依赖问题 所以不使用子文件
    #s.subspec 'DYNetworkProtocol' do |protocol|
    #protocol.source_files = 'DYNetwork/Classes/DYNetworkProtocol/*.{h}'
    #end
    
    #s.subspec 'DYNetworkLogger' do |logger|
    #logger.source_files = 'DYNetwork/Classes/DYNetworkLogger/*.{h,m}'
    #end

    #s.subspec 'DYNetworkConfig' do |config|
    #config.source_files = 'DYNetwork/Classes/DYNetworkConfig/*.{h,m}'
    #config.dependency 'DYNetwork/DYNetworkProtocol'
    #end
    
    #s.subspec 'DYNetworkResponse' do |response|
    #response.source_files = 'DYNetwork/Classes/DYNetworkResponse/*.{h,m}'
    #response.dependency 'DYNetwork/DYNetworkProtocol'
    #response.dependency 'DYNetwork/DYNetworkConfig'
    #end
    
    #s.subspec 'DYNetworkManager' do |manager|
    #manager.source_files = 'DYNetwork/Classes/DYNetworkManager/*.{h,m}'
    #manager.dependency 'DYNetwork/DYNetworkProtocol'
    #manager.dependency 'AFNetworking'
    #end
    
    #s.subspec 'DYNetworkRequest' do |request|
    #request.source_files = 'DYNetwork/Classes/DYNetworkRequest/*.{h,m}'
    #request.dependency 'DYNetwork/DYNetworkProtocol'
    #end
    
    
   s.dependency 'AFNetworking'
   
   
end
