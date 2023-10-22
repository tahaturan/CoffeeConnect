//
//  CategoryWithCoffeeViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 22.10.2023.
//

import UIKit

class CategoryWithCoffeeViewController: UIViewController {
    // MARK: - Properties

    var categoryName: String? {
        didSet {
            updateUIWithCategory()
        }
    }

    var categoryId: String? {
        didSet {
            updateUIWithCategory()
        }
    }

    let categoryWitCoffeeList: [(CoffeeCategoryModel, [CoffeeModel])] = AppData.shared.categoriesWithCoffee!
    var coffeeList: [CoffeeModel] = []
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
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - Helpers

extension CategoryWithCoffeeViewController {
    private func setupUI() {
        configureNavigationBar()
        view.addSubview(tableView)
    }

    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func configureNavigationBar() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]
    }

    private func updateUIWithCategory() {
        guard let categoryName = categoryName else { return }
        guard let categoryID = categoryId else { return }
        navigationItem.title = categoryName

        if let machedCategory = categoryWitCoffeeList.first(where: { $0.0.categoryID == categoryID }) {
            coffeeList = machedCategory.1
        }
        tableView.reloadData()
    }
}

// MARK: - CommentNam

extension CategoryWithCoffeeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.CellIDs.wishListCellID, for: indexPath) as! WishListTableViewCell
        let coffee = coffeeList[indexPath.row]
        DispatchQueue.main.async {
            cell.configureCell(coffee: coffee)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coffee = coffeeList[indexPath.row]
        let detailVC = CoffeeDetailViewController()
        detailVC.coffee = coffee
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
