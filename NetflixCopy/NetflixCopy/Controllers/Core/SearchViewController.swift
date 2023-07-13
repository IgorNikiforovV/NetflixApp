//
//  SearchViewController.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 08.07.2023.
//

import UIKit

class SearchViewController: UIViewController {
    private var contentItems = [Content]()
    
    private var discoverTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()
    
    private var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a movie or a tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        view.backgroundColor = .systemBackground
        view.addSubview(discoverTable)
        discoverTable.dataSource = self
        discoverTable.delegate = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        searchController.searchResultsUpdater = self
        
        fetchSearchMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
}

// MARK: private methods

private extension SearchViewController {
    func configureNavBar() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func fetchSearchMovies() {
        APIManager.shared.getSearchMovies { [weak self] result in
            switch result {
            case .success(let content):
                print(content)
                self?.contentItems = content
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }

        let viewModel = MovieViewModel(content: contentItems[indexPath.item])
        cell.configure(with: viewModel)
        return cell
    }
}

// MARK: UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = contentItems[indexPath.item]
        
        guard let title = movie.originalTitle else { return }
        
        APIManager.shared.getYoutubeMovies(searchQuery: title) { [weak self] result in
            switch result {
            case .success(let videoObject):
                guard let videoObject else { return }

                let viewModel = PreviewViewModel(title: title, titleOverview: movie.overview ?? "", youtubeView: videoObject)
                DispatchQueue.main.async {
                    let controller = PreviewViewController()
                    controller.configure(model: viewModel)
                    self?.navigationController?.pushViewController(controller, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let querySearchText = searchBar.text,
              !querySearchText.trimmingCharacters(in: .whitespaces).isEmpty,
              querySearchText.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        resultsController.delegate = self
        
        APIManager.shared.getSearchMovies(searchQuery: querySearchText) { result in
            switch result {
            case .success(let content):
                DispatchQueue.main.async {
                    resultsController.updateResults(content)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: SearchResultsViewControllerDelegate

extension SearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ viewModel: PreviewViewModel) {
        let controller = PreviewViewController()
        controller.configure(model: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
