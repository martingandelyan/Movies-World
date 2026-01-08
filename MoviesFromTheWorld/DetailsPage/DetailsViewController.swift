//
//  DetailsViewController.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let viewModel: DetailsViewModel
    
    private let headerPosterImageView = UIImageView()
    private let smallPosterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let ratingLabel = UILabel()
    private let genre = UILabel()
    private let runtime = UILabel()
    private let aboutMovieLabel = UILabel()
    private let descriptionOfMovieLabel = UILabel()
    private let favoriteBtn = UIButton(type: .system)
    
    init(imdbID: String) {
        self.viewModel = DetailsViewModel(imdbID: imdbID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.20) {
            self.view.alpha = 1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindDetailViewModel()
        viewModel.loadDetails()
    }
    
    //MARK - UI and Binding setup
    func bindDetailViewModel() {
        viewModel.detailsUploaded = { [weak self] in
            let movie = self?.viewModel.detailsMovie
            guard let movie else { return }
            self?.configure(with: movie)
        }
    }
    
    func setupUI() {
        setupHeaderImage()
        setupSmallPosterArea()
        ratingContainerSetup()
        movieDescriptionDesignSetup()
    }
    
    func setupHeaderImage() {
        headerPosterImageView.translatesAutoresizingMaskIntoConstraints = false
        headerPosterImageView.contentMode = .scaleAspectFill
        headerPosterImageView.clipsToBounds = true
        headerPosterImageView.layer.cornerRadius = 10
        view.addSubview(headerPosterImageView)

        NSLayoutConstraint.activate([
            headerPosterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerPosterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerPosterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerPosterImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.30)
        ])
    }
    
    func setupSmallPosterArea() {
        smallPosterImageView.contentMode = .scaleAspectFill
        smallPosterImageView.clipsToBounds = true
        smallPosterImageView.layer.cornerRadius = 10
        smallPosterImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(smallPosterImageView)

        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            smallPosterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            smallPosterImageView.widthAnchor.constraint(equalToConstant: 90),
            smallPosterImageView.heightAnchor.constraint(equalTo: smallPosterImageView.widthAnchor, multiplier: 1.7),
            smallPosterImageView.topAnchor.constraint(equalTo: headerPosterImageView.bottomAnchor, constant: -70),

            titleLabel.topAnchor.constraint(equalTo:headerPosterImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: smallPosterImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
    }
    
    //MARK - rating container setup
    func ratingContainerSetup() {
        let ratingViewContainer = UIView()
        ratingViewContainer.layer.cornerRadius = 10
        ratingViewContainer.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        let starImageView = UIImageView()
        starImageView.image = UIImage(systemName: "star")
        starImageView.contentMode = .scaleAspectFit
        starImageView.tintColor = .systemOrange
        
        ratingLabel.textColor = .systemOrange
        ratingLabel.font = .boldSystemFont(ofSize: 14)
        
        headerPosterImageView.addSubview(ratingViewContainer)
        ratingViewContainer.addSubview(starImageView)
        ratingViewContainer.addSubview(ratingLabel)
        
        ratingViewContainer.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ratingViewContainer.trailingAnchor.constraint(equalTo: headerPosterImageView.trailingAnchor, constant: -11),
            ratingViewContainer.bottomAnchor.constraint(equalTo: headerPosterImageView.bottomAnchor, constant: -8),
            ratingViewContainer.heightAnchor.constraint(equalToConstant: 24),
            
            starImageView.leadingAnchor.constraint(equalTo: ratingViewContainer.leadingAnchor, constant: 5),
            starImageView.centerYAnchor.constraint(equalTo: ratingViewContainer.centerYAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 10),
            starImageView.heightAnchor.constraint(equalToConstant: 10),
            
            ratingLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 5),
            ratingLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingViewContainer.trailingAnchor, constant: -5)
        ])
    }
    
    func movieDescriptionDesignSetup() {
        // MARK - upperPart of description design
        let labels = [yearLabel, genre, runtime]
        
        labels.forEach {
            $0.textColor = .lightGray
            $0.font = .systemFont(ofSize: 13)
        }
        
        let stackViewOfLabels = UIStackView(arrangedSubviews: [
            yearLabel,
            makeVerticalDivide(),
            runtime,
            makeVerticalDivide(),
            genre
        ])
        
        stackViewOfLabels.axis = .horizontal
        stackViewOfLabels.spacing = 10
        stackViewOfLabels.alignment = .center
        stackViewOfLabels.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackViewOfLabels)
        
        NSLayoutConstraint.activate([
            stackViewOfLabels.topAnchor.constraint(equalTo: smallPosterImageView.bottomAnchor, constant: 30),
            stackViewOfLabels.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
        ])
        
        //MARK - downPart of design
        aboutMovieLabel.text = "About Movie"
        aboutMovieLabel.font = .boldSystemFont(ofSize: 18)
        aboutMovieLabel.textColor = .white
        view.addSubview(aboutMovieLabel)
        
        favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteBtn.tintColor = .red
        favoriteBtn.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self,
                  let movies = viewModel.detailsMovie else { return }
            let isFavorite = viewModel.toggleFavoriteMovie(movie: movies)
            updateFavoriteBtn(isFavorite: isFavorite)
        }), for: .touchUpInside)
        
        let descriptionStack = UIStackView(arrangedSubviews: [
            aboutMovieLabel,
            UIView(),
            favoriteBtn
        ])
        
        descriptionStack.axis = .horizontal
        descriptionStack.alignment = .center
        descriptionStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionStack)
        
        NSLayoutConstraint.activate([
            descriptionStack.topAnchor.constraint(equalTo: stackViewOfLabels.bottomAnchor, constant: 40),
            descriptionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        descriptionOfMovieLabel.numberOfLines = 0
        descriptionOfMovieLabel.font = .systemFont(ofSize: 15)
        descriptionOfMovieLabel.textColor = .lightGray
        
        //MARK - allTogether = "about title" label + description of movie
        let descriptionOfMovieDownStack = UIStackView(arrangedSubviews: [
            descriptionStack,
            makeHorizontalDivide(),
            descriptionOfMovieLabel
            ])
        
        descriptionOfMovieDownStack.axis = .vertical
        descriptionOfMovieDownStack.spacing = 10
        descriptionOfMovieDownStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionOfMovieDownStack)
        
        NSLayoutConstraint.activate([
            descriptionOfMovieDownStack.topAnchor.constraint(equalTo: stackViewOfLabels.bottomAnchor, constant: 30),
            descriptionOfMovieDownStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionOfMovieDownStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func makeVerticalDivide() -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 1),
            view.heightAnchor.constraint(equalToConstant: 14)
        ])
        return view
    }
    
    func makeHorizontalDivide() -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 1)
        ])
        return view
    }
    
    //MARK - favorite Button state
    func updateFavoriteBtn(isFavorite: Bool) {
        if isFavorite {
            favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    private func configure(with movie: MovieDetails) {
        titleLabel.text = movie.title
        yearLabel.text = "🗓️ \(movie.year)"
        genre.text = "🎬 \(movie.genre)"
        runtime.text = "🕒 \(movie.runtime)"
        ratingLabel.text = "\(movie.imdbRating)"
        descriptionOfMovieLabel.text = movie.plot
        
        let isFavoriteMovie = viewModel.isFavorite(movie: movie)
        updateFavoriteBtn(isFavorite: isFavoriteMovie)
        
        smallPosterImageView.setImage(from: movie.poster)
        headerPosterImageView.setImage(from: movie.poster)
    }
}
