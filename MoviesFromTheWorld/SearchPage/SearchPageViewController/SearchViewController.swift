//
//  SearchViewController.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    
    private let emptySearchStateTitleLbl = UILabel()
    private let emptySearchStateSubtitleLbl = UILabel()
    
    private let titleSearchLbl = UILabel()
    private let searchTextField = UITextField()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    private let moreOptionBtn = UIButton(type: .system)
    
    private var searchTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        overrideUserInterfaceStyle = .dark
        setupTitleLbl()
        setupSearchLine()
        setupSearchTableView()
        setupEmptyStateOfSearchLbls()
        loadingIndicatorSetup()
        bindViewModel()

    }
    
    private func bindViewModel() {
        viewModel.updateSrch = { [weak self] in
            self?.updateLoadingIndicatorState()
            self?.searchTableView.reloadData()
            self?.updateEmptyState()
        }
    }
    
    private func updateLoadingIndicatorState() {
        if viewModel.isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    private func updateEmptyState() {
        let shouldShowEmpty = viewModel.isSearching && viewModel.searchedMovies.isEmpty
            emptySearchStateTitleLbl.isHidden = !shouldShowEmpty
            emptySearchStateSubtitleLbl.isHidden = !shouldShowEmpty
            searchTableView.isHidden = shouldShowEmpty
        
        UIView.animate(withDuration: 0.30) {
                self.emptySearchStateTitleLbl.alpha = shouldShowEmpty ? 1 : 0
                self.emptySearchStateSubtitleLbl.alpha = shouldShowEmpty ? 1 : 0
                self.searchTableView.alpha = shouldShowEmpty ? 0 : 1
            }
    }
    
    private func loadingIndicatorSetup() {
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: emptySearchStateTitleLbl.centerXAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: emptySearchStateTitleLbl.topAnchor, constant: -5)
        ])
    }
    
    private func setupEmptyStateOfSearchLbls() {
        emptySearchStateTitleLbl.text = "Oh No Isn't This So Embarassing?"
        emptySearchStateTitleLbl.textColor = .white
        emptySearchStateTitleLbl.font = .systemFont(ofSize: 22, weight: .semibold)
        emptySearchStateTitleLbl.textAlignment = .center
        emptySearchStateTitleLbl.isHidden = true
        emptySearchStateTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptySearchStateTitleLbl)
        
        emptySearchStateSubtitleLbl.text = "I cannot find any movie with this name"
        emptySearchStateSubtitleLbl.textColor = .lightGray
        emptySearchStateSubtitleLbl.font = .systemFont(ofSize: 15)
        emptySearchStateSubtitleLbl.textAlignment = .center
        emptySearchStateSubtitleLbl.numberOfLines = 0
        emptySearchStateSubtitleLbl.isHidden = true
        emptySearchStateSubtitleLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptySearchStateSubtitleLbl)
        
        NSLayoutConstraint.activate([
            emptySearchStateTitleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptySearchStateTitleLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptySearchStateSubtitleLbl.topAnchor.constraint(equalTo: emptySearchStateTitleLbl.bottomAnchor, constant: 20),
            emptySearchStateSubtitleLbl.centerXAnchor.constraint(equalTo: emptySearchStateTitleLbl.centerXAnchor)
        ])
    }

    private func setupTitleLbl() {
        titleSearchLbl.text = "Search"
        titleSearchLbl.textColor = .white
        titleSearchLbl.font = .systemFont(ofSize: 34, weight: .bold)
        titleSearchLbl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleSearchLbl)
        
        NSLayoutConstraint.activate([
            titleSearchLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleSearchLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
        ])
    }
    
    private func setupSearchLine() {
        // LEFT text padding
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 40))
        searchTextField.leftView = leftPadding
        searchTextField.leftViewMode = .always
        
        // RIGHT search icon + padding
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .lightGray
        icon.contentMode = .scaleAspectFit
        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 40))
        icon.frame = CGRect(x: 8, y: 10, width: 20, height: 20)
        rightContainer.addSubview(icon)
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search for movies",
            attributes: [
                .foregroundColor: UIColor.lightGray
            ]
        )
        searchTextField.backgroundColor = UIColor(white: 0.2, alpha: 1)
        searchTextField.textColor = .white
        searchTextField.layer.cornerRadius = 12
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.rightView = rightContainer
        searchTextField.rightViewMode = .always
        searchTextField.tintColor = .white
        view.addSubview(searchTextField)
        
        searchTextField.addAction(UIAction(handler: { [weak self] _ in
            guard self == self else { return }
            self?.searchTextChanged()
        }), for: .editingChanged)
        
        //MARK - dropdown menu
        let image = UIImage(systemName: "ellipsis.circle")
            moreOptionBtn.setImage(image, for: .normal)
            moreOptionBtn.tintColor = .white
            moreOptionBtn.showsMenuAsPrimaryAction = true
            moreOptionBtn.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(moreOptionBtn)
            moreOptionBtn.tintColor = .white
            moreOptionBtn.showsMenuAsPrimaryAction = true
            moreOptionBtn.menu = makeSortMenu()
            
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: titleSearchLbl.bottomAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: moreOptionBtn.leadingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            moreOptionBtn.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            moreOptionBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            moreOptionBtn.widthAnchor.constraint(equalToConstant: 25),
            moreOptionBtn.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func updateMenu() {
        moreOptionBtn.menu = makeSortMenu()
    }
    
    private func makeSortMenu() -> UIMenu {
        let name = UIAction(
            title: "Name",
            state: viewModel.currentSortedType == .name ? .on : .off
        ) { [weak self] _ in
            self?.viewModel.currentSortedType = .name
            self?.viewModel.sortByTitle()
            self?.updateMenu()
        }
        
        let year = UIAction(
            title: "Year",
            state: viewModel.currentSortedType == .year ? .on : .off
        ) { [weak self] _ in
            self?.viewModel.currentSortedType = .year
            self?.viewModel.sortByYear()
            self?.updateMenu()
        }
        
        let type = UIAction(
            title: "Type",
            state: viewModel.currentSortedType == .type ? .on : .off
        ) { [weak self] _ in
            self?.viewModel.currentSortedType = .type
            self?.viewModel.sortByType()
            self?.updateMenu()
        }
        
        return UIMenu(
            title: "",
            options: .singleSelection,
            children: [name, year, type]
        )
    }
    
    private func searchTextChanged() {
        viewModel.search(text: searchTextField.text ?? "")
    }
    
    private func setupSearchTableView() {
        searchTableView.backgroundColor = .black
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.register(SearchViewCell.self, forCellReuseIdentifier: "SearchViewCell")
        
        view.addSubview(searchTableView)
        
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell", for: indexPath) as! SearchViewCell
        
        let searchedMovies = viewModel.searchedMovies[indexPath.row]
        cell.configureSearchedMovies(with: searchedMovies)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentMovie = viewModel.searchedMovies[indexPath.row]
        
        let detailsVC = DetailsViewController(imdbID: currentMovie.imdbID)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

