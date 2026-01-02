//
//  SearchViewCell.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import UIKit

class SearchViewCell: UITableViewCell {
    
    private let titleLbl = UILabel()
    private let movieYearLbl = UILabel()
    private let movieTypeLbl = UILabel()
    private let posterImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        let allFields = [titleLbl, movieYearLbl, movieTypeLbl, posterImageView]
        allFields.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setupPosterAndTitle()
        stackViewOfLbls()
    }
    
    func setupPosterAndTitle() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        
        titleLbl.font = .boldSystemFont(ofSize: 18)
        titleLbl.textColor = .white
        titleLbl.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLbl.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLbl.topAnchor.constraint(equalTo: posterImageView.topAnchor)
        ])
    }
    
    func stackViewOfLbls() {
        [movieYearLbl, movieTypeLbl].forEach {
            $0.font = .systemFont(ofSize: 13)
            $0.textColor = .white
        }
        
        //MARK - stackview
        let stackView = UIStackView()
        stackView.addArrangedSubview(movieYearLbl)
        stackView.addArrangedSubview(movieTypeLbl)
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            stackView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 2),
            stackView.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor)
        ])
    }
    
    func configureSearchedMovies(with movie: Movie) {
        titleLbl.text = movie.title
        movieYearLbl.text = "🗓️ \(movie.year)"
        movieTypeLbl.text = "🎬 \(movie.type)"

        MoviesNetworkManager.shared.loadPosterImage(from: movie.poster) { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
    }
}
