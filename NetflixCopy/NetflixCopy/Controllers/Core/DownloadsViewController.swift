//
//  DownloadsViewController.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 08.07.2023.
//

import UIKit

class DownloadsViewController: UIViewController {
    private var contentItems = [ContentItem]()
    
    private var downloadedTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        
        view.addSubview(downloadedTable)
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        
        fetchLocalStorageForDownload()

        view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("videoDownloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
}

// MARK: private methods

private extension DownloadsViewController {
    func configureNavBar() {
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingVideoContentFromDatabase { [weak self] result in
            switch result {
            case .success(let contentItems):
                self?.contentItems = contentItems
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: UITableViewDataSource

extension DownloadsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let item = contentItems[indexPath.item]
        let posterURL = "\(Constants.posterBaseURL)\(item.posterPath ?? "")"
        let viewModel = MovieViewModel(titleName: item.originalTitle ?? "", posterURL: posterURL)
        cell.configure(with: viewModel)
        return cell
    }
}

// MARK: UITableViewDelegate

extension DownloadsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let contentItem = contentItems[indexPath.item]
            DataPersistenceManager.shared.deleteVideoContent(with: contentItem) { [weak self] result in
                switch result {
                case .success():
                    print("Movie: \(contentItem.originalName ?? "unknown") deleted from database")
                    self?.contentItems.remove(at: indexPath.item)
                    self?.downloadedTable.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
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


