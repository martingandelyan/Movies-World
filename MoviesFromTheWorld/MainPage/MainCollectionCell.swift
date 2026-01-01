//
//  MovieCollectionCell.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import UIKit

class MainCollectionCell: UICollectionViewCell {
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellUI() {
        let views = [posterImageView, titleLabel]
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        titleLabel.numberOfLines = 3
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .white
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 16
        posterImageView.backgroundColor = .clear
        
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5), // Marked
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -6) // Marked
        ])
    }
    
    func configure(with movie: Movie) {
        self.titleLabel.text = movie.title
        
        let moviePosterUrl = movie.poster
        MoviesNetworkManager.shared.loadPosterImage(from: moviePosterUrl) { [weak self] moviePoster in
            DispatchQueue.main.async {
                self?.posterImageView.image = moviePoster
            }
        }
    }
    
    func configureFavorites(with movie: MovieDetails) {
        self.titleLabel.text = movie.title
        
        let moviePosterUrl = movie.poster
        MoviesNetworkManager.shared.loadPosterImage(from: moviePosterUrl) { [weak self] moviePoster in
            DispatchQueue.main.async {
                self?.posterImageView.image = moviePoster
            }
        }
    }
}
