//
//  MovieTableViewCell.swift
//  NetflixCopy
//
//  Created by Игорь Никифоров on 11.07.2023.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moviePesterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(moviePesterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        let moviePesterImageViewConstraints = [
            moviePesterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePesterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            moviePesterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            moviePesterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let playTitleButtonConstraints = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let maxTitleWidth = UIScreen.main.bounds.width - 100 - 20 - 20 - 35 - 20
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: moviePesterImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: maxTitleWidth)
        ]
 
        NSLayoutConstraint.activate(moviePesterImageViewConstraints + titleLabelConstraints + playTitleButtonConstraints)
    }
}


// MARK: public methods

extension MovieTableViewCell {
    public func configure(with model: MovieViewModel) {
        guard let url = URL(string: model.posterURL) else { return }
        moviePesterImageView.sd_setImage(with: url)
        titleLabel.text = model.titleName
    }
}
