//
//  SearchViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 18.10.2023.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Properties

    private var coffees: [(CoffeeCategoryModel, [CoffeeModel])]?
    private var filteredCategoriesWithCoffee: [(CoffeeCategoryModel, [CoffeeModel])]?
    private lazy var favoriteButton: UIButton = createNavigationBarButton(with: AppStyleConstants.Icons.heart, action: #selector(didTapFavorite))
    private lazy var basketButton: UIButton = createNavigationBarButton(with: AppStyleConstants.Icons.cart, action: #selector(didTapBasket))

    private lazy var navbarFavoriteButton = UIBarButtonItem(customView: favoriteButton)
    private lazy var navbarBasketButton = UIBarButtonItem(customView: basketButton)
    private lazy var spacerBarButtonItem: UIBarButtonItem = {
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 24))
        return UIBarButtonItem(customView: spacer)
    }()
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = StringConstants.MainTabbar.search
        searchBar.barTintColor = .white
        searchBar.backgroundColor = .white
        searchBar.backgroundImage = UIImage() // Üst ve alt çizgileri kaldırma
        searchBar.layer.cornerRadius = 30
        searchBar.layer.shadowOpacity = 0.23
        searchBar.layer.shadowRadius = 6
        searchBar.layer.shadowOffset = CGSize(width: 0, height: 6)
        searchBar.layer.shadowColor = AppColors.special.color.cgColor
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.white
            textField.textColor = UIColor.black
            textField.font = UIFont.systemFont(ofSize: 16)
            textField.layer.cornerRadius = 10 // Corner Radius ekledik
            textField.clipsToBounds = true
        }
        searchBar.setImage(UIImage(systemName: AppStyleConstants.Icons.search), for: .search, state: .normal)
        return searchBar
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        tableView.register(WishListTableViewCell.self, forCellReuseIdentifier: StringConstants.CellIDs.wishListCellID)
        return tableView
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        coffees = AppData.shared.categoriesWithCoffee
        filteredCategoriesWithCoffee = coffees
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - Helpers

extension SearchViewController {
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = StringConstants.General.search
        navigationController?.navigationBar.largeContentTitle = StringConstants.General.search
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]
        navigationItem.rightBarButtonItems = [navbarFavoriteButton, spacerBarButtonItem, navbarBasketButton]
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }

    private func setupLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
//MARK: - Selectors
extension SearchViewController {
    @objc private func didTapFavorite() {
        navigationController?.pushViewController(WishListViewController(), animated: true)
    }
    @objc private func didTapBasket() {
        navigationController?.pushViewController(BasketViewController(), animated: true)
    }
}

// MARK: - UITableView  Delegate/DataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCategoriesWithCoffee?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCategoriesWithCoffee?[section].1.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.CellIDs.wishListCellID, for: indexPath) as! WishListTableViewCell
        let coffe = filteredCategoriesWithCoffee?[indexPath.section].1[indexPath.row]
        if let coffe = coffe {
            cell.configureCell(coffee: coffe)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        headerView.backgroundColor = AppColors.backView.color
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerView.layer.shadowOpacity = 0.1
        headerView.layer.shadowRadius = 2
        headerView.layer.cornerRadius = 25
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: headerView.bounds.width - 40, height: 50))
        titleLabel.text = filteredCategoriesWithCoffee?[section].0.categoryName
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coffee = filteredCategoriesWithCoffee?[indexPath.section].1[indexPath.row]
        let detailVC = CoffeeDetailViewController()
        detailVC.coffee = coffee
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCategoriesWithCoffee = coffees
        } else {
            filteredCategoriesWithCoffee = coffees?.compactMap({ coffeCategoryAndModel -> (CoffeeCategoryModel, [CoffeeModel])? in
                let matchingCoffees = coffeCategoryAndModel.1.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                if matchingCoffees.isEmpty {
                    return nil
                } else {
                    return (coffeCategoryAndModel.0, matchingCoffees)
                }
            })
        }
        tableView.reloadData()
    }
}
//MARK: - Factory Methods
extension SearchViewController {
    private func createNavigationBarButton(with iconName: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
