Pod::Spec.new do |s|
  s.name             = 'DYNetwork'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DYNetwork.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/昌/DYNetwork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '昌' => 'dyzhcs' }
  s.source           = { :git => 'https://github.com/昌/DYNetwork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  #s.source_files = 'DYNetwork/Classes/**/*.{h,m}'

    s.subspec 'DYNetworkConfig' do |config|
        config.source_files = 'DYNetwork/Classes/DYNetwork/DYNetworkConfig/*.{h,m}'
    end
    
    s.subspec 'DYNetworkLogger' do |logger|
        logger.source_files = 'DYNetwork/Classes/DYNetwork/DYNetworkLogger/*.{h,m}'
    end
    
    s.subspec 'DYNetworkManager' do |manager|
        manager.source_files = 'DYNetwork/Classes/DYNetwork/DYNetworkManager/*.{h,m}'
    end
    
    s.subspec 'DYProtocol' do |protocol|
        protocol.source_files = 'DYNetwork/Classes/DYNetwork/DYProtocol/*.{h,m}'
    end
    
    s.subspec 'DYRequest' do |request|
        request.source_files = 'DYNetwork/Classes/DYNetwork/DYRequest/*.{h,m}'
    end
    
    s.subspec 'DYResponse' do |response|
        response.source_files = 'DYNetwork/Classes/DYNetwork/DYResponse/*.{h,m}'
    end
  # s.resource_bundles = {
  #   'DYNetwork' => ['DYNetwork/Assets/*.png']
  # }

   s.public_header_files = 'Pod/Classes/**/DYNetwork.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'AFNetworking'
   
   
   
   
end
