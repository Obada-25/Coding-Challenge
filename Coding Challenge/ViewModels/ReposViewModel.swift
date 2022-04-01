//
//  ReposViewModel.swift
//  Coding Challenge
//
//  Created by obada darkznly on 01.04.22.
//

import Foundation
import Combine


class ReposViewModel {
    // MARK: Properties
    
    @Published var repos = [Repo]()
    @Published var isFetching = false
    // Notifies the view about the status of the API request
    private var requestListener: AnyCancellable?
    // Notifies the view if an error happens
    var errorPublisher = CurrentValueSubject<Error?, Never>(nil)
    
    private var pageNumber = 1
    
    // MARK: Methods
    
    /// Fires the api request to fetch an array of repositories
    func getRepositories() {
        isFetching = true
        requestListener = ReposApi.fetchRepos(page: pageNumber)?
         .sink(receiveCompletion: { (completion) in
             self.isFetching = false
             switch completion {
             case .failure(let error):
                 self.errorPublisher.send(error)
             case .finished:
                 break
             }
         }, receiveValue: { response in
             self.repos.append(contentsOf: response)
             self.pageNumber += 1
         })
    }
    /// Resets the array of fetched repositoies and fetches from the beginning
    func refreshFetching() {
        if !isFetching {
            repos = []
            pageNumber = 1
            getRepositories()
        }
    }
}
