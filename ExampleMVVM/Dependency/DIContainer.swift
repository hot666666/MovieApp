//
//  DIContainer.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/8/24.
//

import Foundation

class DIContainer: ObservableObject {
    var appConfiguration: AppConfiguration
    var navigationRouter: NavigationRoutable & ObservableObjectSettable
    
    init(appConfiguration: AppConfiguration = AppConfiguration(),
         navigationRouter: NavigationRoutable & ObservableObjectSettable = NavigationRouter()) {
        self.appConfiguration = appConfiguration
        self.navigationRouter = navigationRouter
    }
    
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!,
            queryParameters: [
                "api_key": appConfiguration.apiKey,
                "language": NSLocale.preferredLanguages.first ?? "en"
            ]
        )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    lazy var moviesRepository: DefaultMoviesRepository = {
        let coreDataStorage = CoreDataStorage.shared
        return DefaultMoviesRepository(dataTransferService: self.apiDataTransferService, 
                                       cache: CoreDataMoviesResponseStorage(coreDataStorage: coreDataStorage))
    }()
    
}
