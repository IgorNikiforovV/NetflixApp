//
//  ContentCollectionViewCell.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 11.07.2023.
//

import UIKit
import SDWebImage

final class ContentCollectionViewCell: UICollectionViewCell {
    static let identifier = "ContentCollectionViewCell"

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
}

// MARK:  public methods

extension ContentCollectionViewCell {
    public func configure(with path: String) {
        guard let url = URL(string: "\(Constants.posterBaseURL)\(path)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}
