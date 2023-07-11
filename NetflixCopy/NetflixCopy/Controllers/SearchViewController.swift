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

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        view.addSubview(discoverTable)
        discoverTable.dataSource = self
        discoverTable.delegate = self
        view.backgroundColor = .systemBackground
        
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
}
