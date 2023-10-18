//
//  WishListViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 18.10.2023.
//

import UIKit

class WishListViewController: UIViewController {
    // MARK: - Properties
    private var wishListCoffees: [CoffeeModel] = []
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
        fetchAndDisplayWishlist()
        setupUI()
        setupLayout()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Helpers

extension WishListViewController {
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = StringConstants.WishlistViewController.wishList
        navigationController?.navigationBar.largeContentTitle = StringConstants.WishlistViewController.wishList
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]
        view.addSubview(tableView)
    }

    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
    
    private func fetchAndDisplayWishlist() {
        guard let userID = UserManager.shared.currentUser?.userID else { return }
        
        DataService.shared.listenToUserWishlist(userID: userID) { [weak self] result in
            switch result {
            case .success(let wishlistItems):
                self?.populateWishlistCoffees(with: wishlistItems)
            case .failure(let error):
                print("Error fetching wishlist: \(error.localizedDescription)")
            }
        }
    }
    private func populateWishlistCoffees(with wishlistItems: [WishlistItemModel]) {
        guard let categoriesWithCoffee = AppData.shared.categoriesWithCoffee else { return }
        
        wishListCoffees.removeAll()
        for wishlistItem in wishlistItems {
            for (_, coffees) in categoriesWithCoffee {
                if let coffee = coffees.first(where: { $0.coffeeID == wishlistItem.coffeeID }) {
                    wishListCoffees.append(coffee)
                }
            }
        }
        tableView.reloadData()
    }
}
//MARK: - CommentNam
extension WishListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishListCoffees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.CellIDs.wishListCellID, for: indexPath) as! WishListTableViewCell
        let coffee = wishListCoffees[indexPath.row]
        cell.configureCell(coffee: coffee)
        return cell
    }
    
}










