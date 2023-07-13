//
//  CollectionViewTableViewCell.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 09.07.2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: PreviewViewModel)
}

final class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    private var contentItems: [Content] = []
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ContentCollectionViewCell.self,
                            forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self

        contentView.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
}

// MARK: public methods

extension CollectionViewTableViewCell {
    public func configure(contentItems: [Content]) {
        self.contentItems = contentItems
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: private methods

private extension CollectionViewTableViewCell {
    func downloadVideoAt(indexPath: IndexPath) {
        print(contentItems[indexPath.item].originalTitle)
    }
}

// MARK: UICollectionViewDataSource

extension CollectionViewTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contentItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let posterPath = contentItems[indexPath.item].posterPath,
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCollectionViewCell.identifier, for: indexPath) as? ContentCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: posterPath)
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension CollectionViewTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let contentItem = contentItems[indexPath.item]
        guard let title = contentItem.originalTitle else { return }
        
        APIManager.shared.getYoutubeMovies(searchQuery: "\(title) trailer") { [weak self] result in
            switch result {
            case .success(let videoObject):
                guard let self = self, let videoObject else { return }
                let viewModel = PreviewViewModel(title: title,
                                                 titleOverview: contentItem.overview ?? "",
                                                 youtubeView: videoObject)
                DispatchQueue.main.async {
                    self.delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: viewModel)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self?.downloadVideoAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
