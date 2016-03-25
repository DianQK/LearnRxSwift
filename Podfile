platform :ios, "8.0"

use_frameworks!

def rx_pods
    pod 'RxSwift',:git => 'https://github.com/ReactiveX/RxSwift.git', :branch => 'develop'
    pod 'RxCocoa',:git => 'https://github.com/ReactiveX/RxSwift.git', :branch => 'develop'
end

def rx_test_pods
    pod 'RxTests'
end

def rx_ext_pods
    pod 'RxDataSources',:git => 'https://github.com/RxSwiftCommunity/RxDataSources.git'
end

def net_pods
    pod 'Alamofire'
    pod 'RxAlamofire'
    pod 'Moya'
    pod 'Moya/RxSwift'
end

def model_pods
    pod 'ObjectMapper'
end

target 'RxWhy' do
    rx_pods
end

target 'RxTableView' do
    rx_pods
    rx_ext_pods
end

target 'RxNetwork' do
    rx_pods
    rx_ext_pods
    net_pods
    model_pods
end

target 'RxScheduler' do
    rx_pods
end