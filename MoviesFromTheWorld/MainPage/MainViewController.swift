//
//  HomeScreenViewController.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import UIKit

class MainViewController: UIViewController {
    
    private let moviesStaticLbl = UILabel()
    
    private let viewModel = MoviesMainViewModel()
    
    private let moviesCollectionView: UICollectionView = {
        let configuration = UICollectionViewFlowLayout()
        configuration.scrollDirection = .vertical
        
        let spacing: CGFloat = 8
        let inset: CGFloat = 16
        
        let screenWidth = UIScreen.main.bounds.width
        let itemsPerRow: CGFloat = screenWidth < 375 ? 2 : 3
        let totalSpacing = (itemsPerRow - 1) * spacing + inset * 2
        let itemWidth = (screenWidth - totalSpacing) / itemsPerRow
       
        
        configuration.sectionInset = UIEdgeInsets(top: inset, left: spacing, bottom: inset, right: spacing)
        
        configuration.minimumLineSpacing = spacing
        configuration.minimumInteritemSpacing = spacing
        configuration.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configuration)
        collectionView.backgroundColor = .black
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        print("main view controller loaded")
        setupUI()
        bindViewModelToView()
        loadMovies()
        
    }
    
    func loadMovies() {
        viewModel.loadRandomMovies()
    }
    
    func bindViewModelToView() {
        viewModel.moviesUploaded = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
            }
        }
    }
    
    func setupMovieTitleLbl() {
        view.addSubview(moviesStaticLbl)
        moviesStaticLbl.translatesAutoresizingMaskIntoConstraints = false
        moviesStaticLbl.text = "Movies"
        moviesStaticLbl.textColor = .white
        moviesStaticLbl.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        
        NSLayoutConstraint.activate([
            moviesStaticLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            moviesStaticLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
        ])
    }
    
    func setupMoviesCollectionView() {
        view.addSubview(moviesCollectionView)
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.backgroundColor = .clear
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: "MainCollectionCell")
        
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: moviesStaticLbl.bottomAnchor, constant: 20),
            moviesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            moviesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupUI() {
        setupMovieTitleLbl()
        setupMoviesCollectionView()
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionCell", for: indexPath) as! MainCollectionCell
        
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        
        return cell
    }
}

//extension MainViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemsPerRow: CGFloat = 3
//        
//    }
//}

extension MainViewController: UICollectionViewDelegate {
    
}






import SwiftUI

#Preview {
    MainViewController()
}

