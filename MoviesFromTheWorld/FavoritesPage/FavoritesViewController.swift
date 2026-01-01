//
//  FavoritesViewController.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let viewModel = FavoritesViewModel.shared
    
    private let favoritesStaticLbl = UILabel()
    
    private let favoritesCollectionView: UICollectionView = {
        let configuration = UICollectionViewFlowLayout()
        configuration.scrollDirection = .vertical
        
        let spacing: CGFloat = 8
        let inset: CGFloat = 16
        
        let screenWidth = UIScreen.main.bounds.width
        let itemsPerRow: CGFloat = screenWidth < 375 ? 2 : 3
        let totalSpacing = (itemsPerRow - 1) * spacing + inset * 2
        let itemWidth = (screenWidth - totalSpacing) / itemsPerRow
       
        
        configuration.sectionInset = UIEdgeInsets(top: inset, left: spacing, bottom: inset, right: spacing)
        
        configuration.minimumLineSpacing = 20
        configuration.minimumInteritemSpacing = spacing
        configuration.itemSize = CGSize(width: itemWidth, height: itemWidth * 2.1)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configuration)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.movieAdded = { [weak self] in
            DispatchQueue.main.async {
                self?.favoritesCollectionView.reloadData()
            }
        }
    }
    
    func setupUI() {
        setupDetailsTitleLbl()
        setupMoviesCollectionView()
    }
    
    func setupDetailsTitleLbl() {
        favoritesStaticLbl.translatesAutoresizingMaskIntoConstraints = false
        favoritesStaticLbl.text = "Favorites"
        favoritesStaticLbl.textColor = .white
        favoritesStaticLbl.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        view.addSubview(favoritesStaticLbl)
        
        NSLayoutConstraint.activate([
            favoritesStaticLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            favoritesStaticLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
        ])
    }
    
    func setupMoviesCollectionView() {
        view.addSubview(favoritesCollectionView)
        favoritesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favoritesCollectionView.backgroundColor = .clear
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: "MainCollectionCell")
        
        NSLayoutConstraint.activate([
            favoritesCollectionView.topAnchor.constraint(equalTo: favoritesStaticLbl.bottomAnchor, constant: 5),
            favoritesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            favoritesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            favoritesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionCell", for: indexPath) as! MainCollectionCell
        
        let movie = viewModel.favoriteMovies[indexPath.row]
        cell.configureFavorites(with: movie)
        
        return cell
    }
}

extension FavoritesViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.favoriteMovies[indexPath.row]
        let detailsVCFromFavorites = DetailsViewController(imdbID: movie.imdbID)
        navigationController?.pushViewController(detailsVCFromFavorites, animated: true)
    }
}
