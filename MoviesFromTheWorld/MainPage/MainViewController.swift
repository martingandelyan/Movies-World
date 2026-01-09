//
//  HomeScreenViewController.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK - Static label of the view
    private let moviesStaticLbl = UILabel()
    
    //MARK - Main page view model
    private let viewModel = MoviesMainViewModel()
    
    //MARK - Collection view setup for Main page
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
        
        configuration.minimumLineSpacing = 20
        configuration.minimumInteritemSpacing = spacing
        configuration.itemSize = CGSize(width: itemWidth, height: itemWidth * 2.1)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configuration)
        collectionView.backgroundColor = .black
        return collectionView
    }()

    //MARK - App loading
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        print("main view controller loaded")
        setupUI()
        bindViewModelToView()
        loadMovies()
    }
    
    //MARK - Load random movies
    func loadMovies() {
        viewModel.loadRandomMovies()
    }
    
    //MARK - Binding of ViewModel to current view
    func bindViewModelToView() {
        viewModel.moviesUploaded = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                UIView.transition(with: self.moviesCollectionView, duration: 0.3, options: .transitionCrossDissolve) {
                    self.moviesCollectionView.reloadData()
                }
            }
        }
    }
    
    //MARK - Setup Main page UI
    func setupUI() {
        setupMovieTitleLbl()
        setupMoviesCollectionView()
    }
    
    func setupMovieTitleLbl() {
        moviesStaticLbl.translatesAutoresizingMaskIntoConstraints = false
        moviesStaticLbl.text = "Movies"
        moviesStaticLbl.textColor = .white
        moviesStaticLbl.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        view.addSubview(moviesStaticLbl)
        
        NSLayoutConstraint.activate([
            moviesStaticLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            moviesStaticLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
        ])
    }
    
    //MARK - registration of collection view
    func setupMoviesCollectionView() {
        view.addSubview(moviesCollectionView)
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.backgroundColor = .clear
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: "MainCollectionCell")
        
        NSLayoutConstraint.activate([
            moviesCollectionView.topAnchor.constraint(equalTo: moviesStaticLbl.bottomAnchor, constant: 5),
            moviesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            moviesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        
        viewModel.loadMoreOnMainIfNeeded(index: indexPath.row)
                
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        
        let detailsVC = DetailsViewController(imdbID: movie.imdbID)
        detailsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailsVC, animated: true)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //MARK - Smooth animation for each cell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(
            withDuration: 0.3,
            delay: 0.05 * Double(indexPath.row % 6),
            options: [.curveEaseOut]
        ) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.1) {
            cell?.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.1) {
            cell?.transform = .identity
        }
    }
}

