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
    private let orderView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var subTotalLabel: UILabel = createLabel(title: StringConstants.General.subTotal)
    private lazy var subTotalPriceLabel: UILabel = createLabel(title: "")
    private lazy var deliveryLabel: UILabel = createLabel(title: StringConstants.General.delivery)
    private lazy var deliveryPriceLabel: UILabel = createLabel(title: "10₺")
    private lazy var totalLabel: UILabel = createLabel(title: StringConstants.General.total, size: 20, isBold: true)
    private lazy var totalPriceLavel: UILabel = createLabel(title: "",size: 20, isBold: true)
    private let seperatorLine: UIView = {
       let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.2)
        return view
    }()
    private let orderButton: CustomButton = CustomButton(title: StringConstants.General.order)
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
        view.addSubview(orderView)
        orderView.addSubview(subTotalLabel)
        orderView.addSubview(subTotalPriceLabel)
        orderView.addSubview(deliveryLabel)
        orderView.addSubview(deliveryPriceLabel)
        orderView.addSubview(seperatorLine)
        orderView.addSubview(totalLabel)
        orderView.addSubview(totalPriceLavel)
        orderView.addSubview(orderButton)
    }
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(370)
        }
        orderView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
        }
        subTotalLabel.snp.makeConstraints { make in
            make.top.equalTo(orderView.snp.top).offset(10)
            make.leading.equalTo(orderView.snp.leading).offset(40)
        }
        subTotalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(subTotalLabel)
            make.trailing.equalTo(orderView.snp.trailing).offset(-40)
        }
        deliveryLabel.snp.makeConstraints { make in
            make.top.equalTo(subTotalLabel.snp.bottom).offset(10)
            make.leading.equalTo(subTotalLabel)
        }
        deliveryPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(subTotalPriceLabel.snp.bottom).offset(10)
            make.trailing.equalTo(subTotalPriceLabel)
        }
        seperatorLine.snp.makeConstraints { make in
            make.top.equalTo(deliveryLabel.snp.bottom).offset(10)
            make.leading.equalTo(deliveryLabel)
            make.trailing.equalTo(deliveryPriceLabel)
            make.height.equalTo(1)
        }
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(seperatorLine.snp.bottom).offset(10)
            make.leading.equalTo(seperatorLine)
        }
        totalPriceLavel.snp.makeConstraints { make in
            make.top.equalTo(totalLabel)
            make.trailing.equalTo(seperatorLine)
        }
        orderButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(40)
            make.leading.trailing.equalTo(seperatorLine)
            make.height.equalTo(50)
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
    private func configurePriceLabel() {
        var subTotal = 0.0
        for (coffee, quantity) in basketCoffees {
             subTotal += coffee.price * Double(quantity)
        }
        DispatchQueue.main.async {
            self.subTotalPriceLabel.text = "\(subTotal)₺"
            self.totalPriceLavel.text = "\(subTotal + 10)₺"
        }
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
        configurePriceLabel()
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
//MARK: - Factory Methods
extension BasketViewController {
    private func createLabel(title: String, size: CGFloat? = 15, isBold: Bool? = false) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = isBold! ? UIFont.boldSystemFont(ofSize: size!) : UIFont.boldSystemFont(ofSize: size!)
        return label
    }
}
