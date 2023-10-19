//
//  BasketViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 18.10.2023.
//

import UIKit
import SnapKit

class BasketViewController: UIViewController {
    //MARK: - Properties
    private var basketCoffees: [(CoffeeModel, Int)] = [] // CoffeeModel ve miktarı (quantity) olarak bir tuple
    private var tableView: UITableView = {
       let tableView = UITableView()
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        tableView.register(BasketListTableViewCell.self, forCellReuseIdentifier: StringConstants.CellIDs.basketListCellID)
        return tableView
    }()
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndDisplayBasket()
        setupUI()
        setupLayout()
        tableView.delegate = self
        tableView.dataSource = self
    }
}
//MARK: - Helepers
extension BasketViewController {
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = StringConstants.BasketViewController.basket
        navigationController?.navigationBar.largeContentTitle = StringConstants.BasketViewController.basket
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
    
    private func fetchAndDisplayBasket() {
        guard let userID = UserManager.shared.currentUser?.userID else { return }
        DataService.shared.listenToUserShoppingCart(userID: userID) { [weak self] result in
            switch result {
            case .success(let shoppingCart):
                self?.populateBasketCoffees(with: shoppingCart.items)
            case .failure(let error):
                self!.showAlert(title: StringConstants.General.error, message: error.localizedDescription)
            }
        }
    }
    
    private func populateBasketCoffees(with basketItems: [ShoppingCartItemModel]) {
        guard let categoriesWithCoffee = AppData.shared.categoriesWithCoffee else { return }
        basketCoffees.removeAll()
        for basketItem in basketItems {
            for (_, coffees) in categoriesWithCoffee {
                if let coffee = coffees.first(where: {$0.coffeeID == basketItem.coffeeID}) {
                    basketCoffees.append((coffee, basketItem.quantity))
                }
            }
        }
        tableView.reloadData()
    }
}

//MARK: -UITableView Delegate/DataSource
extension BasketViewController: UITableViewDelegate, UITableViewDataSource , BasketListTableViewCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketCoffees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.CellIDs.basketListCellID, for: indexPath) as! BasketListTableViewCell
        let (coffee, quantity) = basketCoffees[indexPath.row]
        cell.configureCell(coffee: coffee, quantity: quantity)
        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func didTapIncreaseButton(cell: BasketListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let coffee = basketCoffees[indexPath.row].0
        if let user = UserManager.shared.currentUser {
            DataService.shared.increaseCoffeeQuantityInBasket(userID: user.userID, coffeeID: coffee.coffeeID) { [weak self] result in
                switch result {
                case .success():
                    self?.fetchAndDisplayBasket()
                case .failure(let error):
                    self!.showAlert(title: StringConstants.General.error, message: error.localizedDescription)
                }
            }
        }
    }
    
    func didTapDecreaseButton(cell: BasketListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let coffee = basketCoffees[indexPath.row].0
        if let user = UserManager.shared.currentUser {
            DataService.shared.decreaseCoffeeQuantityInBasket(userID: user.userID, coffeeID: coffee.coffeeID) { [weak self] result in
                 switch result {
                 case .success():
                     self?.fetchAndDisplayBasket()
                 case .failure(let error):
                     self!.showAlert(title: StringConstants.General.error, message: error.localizedDescription)
                 }
             }
        }
    }
    
    func didTapDeleteButton(cell: BasketListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let coffee = basketCoffees[indexPath.row].0
        if let user = UserManager.shared.currentUser {
            DataService.shared.removeCoffeeFromBasket(userID: user.userID, coffeeID: coffee.coffeeID) { [weak self] result in
                switch result {
                case .success():
                    self?.fetchAndDisplayBasket()
                    self!.showAlert(title: StringConstants.General.success, message: StringConstants.General.deletedProduct)
                case .failure(let error):
                    self!.showAlert(title: StringConstants.General.error, message: error.localizedDescription)
                    
                }
            }
        }
    }
}
