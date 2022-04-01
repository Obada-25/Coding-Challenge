//
//  ReposTableVC.swift
//  Coding Challenge
//
//  Created by obada darkznly on 01.04.22.
//

import UIKit
import Combine


class ReposVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: Properties
    let viewModel = ReposViewModel()
    // Updates the list with new repositories
    var fetchingSubscriber: AnyCancellable?
    var errorSubscriber: AnyCancellable?
    var activityIndicator = UIActivityIndicatorView()
    // Used for resetting the repos array
    var shouldResetFetching = false
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeView()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getRepositories()
        bindData()
    }
    
    // MARK: Data binding
    
    /// Allows the view controller to listen to the changes in the view model
    func bindData() {
        fetchingSubscriber = viewModel.$isFetching.sink(receiveValue: { fetching in
            self.showActivityIndicator(fetching)
            if !fetching {
                self.tableView.reloadData()
            }
        })
        errorSubscriber = viewModel.errorPublisher.sink(receiveValue: { error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    // MARK: View's customization
    func customizeView() {
        self.navigationItem.title = "Apple Repositories"
        let loadingIndicatorBarItem = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.leftBarButtonItem = loadingIndicatorBarItem
        let refreshBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPressed))
        self.navigationItem.rightBarButtonItem = refreshBarItem
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let repoCellNib = UINib(nibName: Constants.repoCellNibName, bundle: nil)
        tableView.register(repoCellNib, forCellReuseIdentifier: Constants.reposCellReuseId)
        
    }
    
    func showActivityIndicator(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: Actions
    @objc func refreshPressed() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        shouldResetFetching = true
    }
    
}

// MARK: UITableViewDelegate & Data source
extension ReposVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ReposVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reposCellReuseId,
                                                       for: indexPath) as? RepoCell else { return UITableViewCell() }
        cell.populate(viewModel.repos[indexPath.row])
        return cell
    }
}

// MARK: Scroll view delegate

extension ReposVC {
    /// Checks if the scroll position is at the bottom to fetch more data
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !viewModel.isFetching {
                viewModel.getRepositories()
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //  Prevents the tableView from reloading before the animation is finished (If the refresh button is pressed)
        if shouldResetFetching {
            viewModel.refreshFetching()
            shouldResetFetching.toggle()
        }
    }
}

