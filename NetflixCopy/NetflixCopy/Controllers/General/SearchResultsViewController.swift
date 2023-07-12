//
//  SearchResultsViewController.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 12.07.2023.
//

import UIKit

class SearchResultsViewController: UIViewController {
    private var contentItems = [Content]()
    
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
}
