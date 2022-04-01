//
//  NetworkManager.swift
//  Coding Challenge
//
//  Created by obada darkznly on 01.04.22.
//

import Foundation
import Combine

/// A wrapper for URLSessions using combine
fileprivate struct ApiAgent {
    
    /// The response type
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    /** Generic method that fires an Api request, decodes the response and emmits the returned value to a subscriber
     - Parameter request: The url request that should be fired
     - Parameter decoder: The json decoder used in decoding the response value
     
     - Returns: A generic Any publisher that emmits the decoded response
     */
    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
        }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum ReposApi {
    fileprivate static let apiAgent = ApiAgent()
    fileprivate static let baseUrl = URL(string: "https://api.github.com/")
    fileprivate static let repositoriesEndpoint = baseUrl?.appendingPathComponent("orgs/apple/repos")
}

extension ReposApi {
    
    static func fetchRepos(page: Int = 1) -> AnyPublisher<[Repo], Error>? {
        guard let reposUrl = ReposApi.repositoriesEndpoint else { return nil }
        
        guard var components = URLComponents(url: reposUrl, resolvingAgainstBaseURL: false) else { return nil }
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "sort", value: "full_name")
        ]
        
        let request = URLRequest(url: components.url!)
        return apiAgent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
