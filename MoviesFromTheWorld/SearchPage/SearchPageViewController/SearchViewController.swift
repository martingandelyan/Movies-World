//
//  SearchViewController.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    
    private let titleSearchLbl = UILabel()
    private let searchTextField = UITextField()
    
    private let moreOptionBtn = UIButton(type: .system)
    
    private var searchTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTitleLbl()
        setupSearchLine()
        setupSearchTableView()
        bindViewModel()

    }
    
    private func bindViewModel() {
        viewModel.updateSrch = { [weak self] in
            self?.searchTableView.reloadData()
        }
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
        
        let image = UIImage(systemName: "ellipsis.circle")
            moreOptionBtn.setImage(image, for: .normal)
            moreOptionBtn.tintColor = .white
            moreOptionBtn.showsMenuAsPrimaryAction = true
            moreOptionBtn.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(moreOptionBtn)

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

