//
//  SearchResultsViewController.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 12.07.2023.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: PreviewViewModel)
}

final class SearchResultsViewController: UIViewController {
    private var contentItems = [Content]()
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private var searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(searchResultsCollectionView)
        view.backgroundColor = .systemBackground
        
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
}

// MARK: public methods

extension SearchResultsViewController {
    public func updateResults(_ contentItems: [Content]) {
        self.contentItems = contentItems
        searchResultsCollectionView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension SearchResultsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contentItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as? ContentCollectionViewCell else {
            return UICollectionViewCell()
        }

        let posterPath = contentItems[indexPath.item].posterPath ?? ""
        cell.configure(with: posterPath)
        return cell
    }
}

// MARK: UITableViewDelegate

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = contentItems[indexPath.item]
        
        guard let title = movie.originalTitle else { return }
        
        APIManager.shared.getYoutubeMovies(searchQuery: title) { [weak self] result in
            switch result {
            case .success(let videoObject):
                guard let videoObject else { return }

                let viewModel = PreviewViewModel(title: title, titleOverview: movie.overview ?? "", youtubeView: videoObject)
                DispatchQueue.main.async {
                    self?.delegate?.searchResultsViewControllerDidTapItem(viewModel)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
