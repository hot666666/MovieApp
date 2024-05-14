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
        self.navigationRouter.setObjectWillChange(objectWillChange)
    }
    
    // MARK: - Provider
    lazy var posterImageUrlProvider: PosterImageUrlProvider = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.imageBaseURL)!
        )
       return DefaultPosterImageUrlProvider(networkConfigurable: config)
    }()
    
    // MARK: - Service
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
    
    // MARK: - Persistent Storage
    lazy var moviesQueriesStorage: MoviesQueriesStorage = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    lazy var moviesResponseCache: MoviesResponseStorage = CoreDataMoviesResponseStorage()
    
    // MARK: - Repositories
    lazy var moviesRepository: MoviesRepository = {
        DefaultMoviesRepository(
            dataTransferService: apiDataTransferService,
            cache: moviesResponseCache
        )
    }()
    lazy var moviesQueriesRepository: MoviesQueriesRepository = {
       DefaultMoviesQueriesRepository(moviesQueriesPersistentStorage: moviesQueriesStorage)
    }()
    
    // MARK: - Use Cases
    lazy var searchMoviesUseCase: DefaultSearchMoviesUseCase = {
        DefaultSearchMoviesUseCase(moviesRepository: moviesRepository, moviesQueriesRepository: moviesQueriesRepository)
    }()
    
    lazy var moviesQueriesUseCase: FetchRecentMovieQueriesUseCase = {
        FetchRecentMovieQueriesUseCase(requestValue: .init(maxCount: 10), moviesQueriesRepository: moviesQueriesRepository)
    }()
}

extension DIContainer{
    static var stub: DIContainer {
        .init()
    }
}
