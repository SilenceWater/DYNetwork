Pod::Spec.new do |s|
  s.name             = 'DYNetwork'
  s.version          = '0.1.0'
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
  
    #s.subspec 'DYNetworkConfig' do |config|
    #config.source_files = 'DYNetwork/Classes/DYNetworkConfig/*.{h,m}'
    #end
    
    #s.subspec 'DYNetworkLogger' do |logger|
    #logger.source_files = 'DYNetwork/Classes/DYNetworkLogger/*.{h,m}'
    #end
    
    #s.subspec 'DYNetworkManager' do |manager|
    #manager.source_files = 'DYNetwork/Classes/DYNetworkManager/*.{h,m}'
    #end
    
    #s.subspec 'DYNetworkProtocol' do |protocol|
    #protocol.source_files = 'DYNetwork/Classes/DYNetworkProtocol/*.{h,m}'
    #end
    
    #s.subspec 'DYNetworkRequest' do |request|
    #request.source_files = 'DYNetwork/Classes/DYNetworkRequest/*.{h,m}'
    #end
    
    #s.subspec 'DYNetworkResponse' do |response|
    #response.source_files = 'DYNetwork/Classes/DYNetworkResponse/*.{h,m}'
    #end
  
   s.dependency 'AFNetworking'
   
   
end
