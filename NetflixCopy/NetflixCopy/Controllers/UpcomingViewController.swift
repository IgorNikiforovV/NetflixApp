//
//  UpcomingViewController.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 08.07.2023.
//

import UIKit

final class UpcomingViewController: UIViewController {
    private var contentItems = [Content]()

    private var upcomingTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        view.addSubview(upcomingTable)
        upcomingTable.dataSource = self
        upcomingTable.delegate = self
        view.backgroundColor = .systemBackground
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
}

// MARK: private methods

private extension UpcomingViewController {
    func configureNavBar() {
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func fetchUpcoming() {
        APIManager.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let content):
                self?.contentItems = content
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: UITableViewDataSource

extension UpcomingViewController: UITableViewDataSource {
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

extension UpcomingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
}

