//
//  HomeViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 10.10.2023.
//

import FirebaseAuth
import SDWebImage
import SnapKit
import UIKit



class HomeViewController: UIViewController {
    // MARK: - Properties

    private var didSetupMask = false
    private let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = AppColors.vanillaMocha.color.cgColor
        imageView.layer.cornerRadius = AppStyleConstants.homeUserImageSize / 2
        return imageView
    }()

    private lazy var welcomeLabel: UILabel = createLabel()
    // Favori ve Sepet butunlari
    private lazy var favoriteButton: UIButton = createNavigationBarButton(with: AppStyleConstants.Icons.heart, action: #selector(didTapFavorite))
    private lazy var basketButton: UIButton = createNavigationBarButton(with: AppStyleConstants.Icons.cart, action: #selector(didTapBasket))

    private lazy var navbarFavoriteButton = UIBarButtonItem(customView: favoriteButton)
    private lazy var navbarBasketButton = UIBarButtonItem(customView: basketButton)
    private lazy var spacerBarButtonItem: UIBarButtonItem = {
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 24))
        return UIBarButtonItem(customView: spacer)
    }()

    // Ekran arkaplan gorunumu
    private let bacgroungView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.backView.color
        return view
    }()

    // Kategoriler basligi
    private lazy var categoryLabel: UILabel = createLabel(text: StringConstants.General.categories, font: UIFont.boldSystemFont(ofSize: 25))

    private lazy var pagingView: PagingView = {
        let view = PagingView(models: SpecialModel.dummyList)
        view.isUserInteractionEnabled = true
        return view
    }()
    private lazy var featuredProductLabel: UILabel = createLabel(text: StringConstants.HomeView.featuredProduct, font: UIFont.boldSystemFont(ofSize: 20))
    private lazy var allCategoriesButton: UIButton = createAllViewButton(action: #selector(allCategoryButtonTapped))
    private lazy var allFeaturedButton: UIButton = createAllViewButton(action: #selector(allFeaturedButtonTapped))
    var featuredProductList: (CoffeeCategoryModel, [CoffeeModel])?
    private lazy var feateuredCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 160)
        layout.minimumLineSpacing = 40
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.contentInsetAdjustmentBehavior = .never
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.delegate = self
        cv.dataSource = self
        cv.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: StringConstants.CellIDs.homeViewCollectionViewCellId)
        return cv
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        fetchFeatureProduct()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        feateuredCollectionView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didSetupMask {
            let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 30))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            bacgroungView.layer.mask = shape
            didSetupMask = true
        }
    }
}

// MARK: - Helper

extension HomeViewController {
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        view.addSubview(userProfileImageView)
        loadUserProfileImage()
        view.addSubview(welcomeLabel)
        view.addSubview(bacgroungView)
        bacgroungView.addSubview(categoryLabel)
        setupCategoryButtons()
        bacgroungView.addSubview(pagingView)
        bacgroungView.addSubview(featuredProductLabel)
        bacgroungView.addSubview(allCategoriesButton)
        bacgroungView.addSubview(allFeaturedButton)
        bacgroungView.addSubview(feateuredCollectionView)
    }

    // Ekran icin gorunumlerin konumlandirilmasi
    private func setupLayout() {
        userProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(view.snp.leading).offset(5)
            make.height.width.equalTo(AppStyleConstants.homeUserImageSize)
        }
        welcomeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userProfileImageView.snp.centerY)
            make.left.equalTo(userProfileImageView.snp.right).offset(10)
        }
        bacgroungView.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView.snp.bottom).offset(10)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(bacgroungView).offset(10)
            make.leading.equalTo(bacgroungView).offset(20)
        }
        allCategoriesButton.snp.makeConstraints { make in
            make.centerY.equalTo(categoryLabel)
            make.trailing.equalTo(bacgroungView).offset(-20)
        }
        pagingView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(160)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(160)
        }
        featuredProductLabel.snp.makeConstraints { make in
            make.top.equalTo(pagingView.snp.bottom).offset(20)
            make.leading.equalTo(bacgroungView).offset(20)
        }
        allFeaturedButton.snp.makeConstraints { make in
            make.centerY.equalTo(featuredProductLabel)
            make.trailing.equalTo(bacgroungView).offset(-20)
        }
        feateuredCollectionView.snp.makeConstraints { make in
            make.top.equalTo(featuredProductLabel.snp.bottom).offset(-10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
    }

    private func loadUserProfileImage() {
        if let user = UserManager.shared.currentUser {
            DispatchQueue.global(qos: .background).async {
                ImageLoader.shared.loadImage(into: self.userProfileImageView, from: user.profileImageURL)
                DispatchQueue.main.async {
                    self.welcomeLabel.text = "\(StringConstants.HomeView.welcome) \(user.name)"
                }
            }
        }
    }

    // NavBar ozellikleri
    private func setupNavigationBar() {
        navigationItem.title = StringConstants.General.appName
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]
        navigationItem.rightBarButtonItems = [navbarFavoriteButton, spacerBarButtonItem, navbarBasketButton]
    }

    // Kategori Butonlarinin olsuturulmasi
    private func setupCategoryButtons() {
        setupCategoriesRow(categories: StringConstants.HomeView.topCategories, topOffset: 20) // üst sıra için
        setupCategoriesRow(categories: StringConstants.HomeView.bottomCategories, topOffset: 90) // alt sıra için, offset değerini ayarlayarak butonların arasındaki boşluğu ayarliyoruz
    }
    
    private func fetchFeatureProduct() {
        if let allCategoriesWithCoffee = AppData.shared.categoriesWithCoffee {
            featuredProductList = allCategoriesWithCoffee.first {$0.0.categoryName == "Özel Karışımlar"}
        }
    }


}

// MARK: - Selector

extension HomeViewController {
    // Favori butonuna tıklandığında yapılacak işlemler
    @objc private func didTapFavorite() {
        navigationController?.pushViewController(WishListViewController(), animated: true)
    }

    // Sepet butonuna tıklandığında yapılacak işlemler
    @objc private func didTapBasket() {
        navigationController?.pushViewController(BasketViewController(), animated: true)
    }
    
    @objc private func allCategoryButtonTapped() {
        // TODO: Implement this function
    }
    @objc private func allFeaturedButtonTapped() {
        // TODO: Implement this function
    }

    // kategori butonlarina tıklandığında yapılacak işlemler
    @objc private func didTapCategoryButton(_ sender: UIButton) {
        if let categoryTitle = sender.titleLabel?.text {
            if let allCategoriesWithCoffee = AppData.shared.categoriesWithCoffee {
                let coffeTuple = allCategoriesWithCoffee.first {$0.0.categoryName == categoryTitle}
               let categoryId = coffeTuple?.0.categoryID
                let categoryVC = CategoryWithCoffeeViewController()
                    categoryVC.categoryName = categoryTitle
                categoryVC.categoryId = categoryId
                    navigationController?.pushViewController(categoryVC, animated: true)
            }
        }
    }
}

// MARK: - Factory Methods

extension HomeViewController {
    // NavBar Buttonlari olsuturmak icin bir fabrika(Factory Method) olusuturuyoruz
    private func createNavigationBarButton(with iconName: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    private func setupCategoriesRow(categories: [String], topOffset: CGFloat) {
        let buttonWidth = (view.frame.width - 60) / 3 // 20'lik padding ile 3'e bölüyoruz.
        var lastButton: UIButton?

        for category in categories {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.layer.cornerRadius = AppStyleConstants.categoryButtonHeight / 2
            button.backgroundColor = UIColor.white
            button.setTitleColor(UIColor.gray, for: .normal)
            button.addTarget(self, action: #selector(didTapCategoryButton(_:)), for: .touchUpInside)
            bacgroungView.addSubview(button)

            button.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(AppStyleConstants.categoryButtonHeight)
                make.top.equalTo(categoryLabel.snp.bottom).offset(topOffset)

                if let lastBtn = lastButton {
                    make.leading.equalTo(lastBtn.snp.trailing).offset(10)
                } else {
                    make.leading.equalTo(bacgroungView).offset(25)
                }
            }
            lastButton = button
        }
    }

    // Label
    private func createLabel(text: String? = nil, font: UIFont? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font ?? UIFont.systemFont(ofSize: 20)
        return label
    }
    
    private func createAllViewButton(action: Selector) -> UIButton {
            let button = UIButton()
        button.setTitle(StringConstants.HomeView.viewAll, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: action, for: .touchUpInside)
            return button
    }
}


//MARK: - UICollection View Delegate/DataSource FeatureCollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, FeatureCollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featuredProductList?.1.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StringConstants.CellIDs.homeViewCollectionViewCellId, for: indexPath) as! FeaturedCollectionViewCell
        if let products = featuredProductList?.1 {
            let coffee = products[indexPath.row]
            cell.configure(with: coffee)
            if let wishList = UserManager.shared.currentUser?.wishlist {
                if wishList.contains(where: {$0.coffeeID == coffee.coffeeID}){
                    cell.favoriteButton.tintColor = .red
                }else{
                    cell.favoriteButton.tintColor = .lightGray
                }
            }
        }
        cell.delegate = self
        return cell
    }
    
    func didTapFavoriteButton(in cell: FeaturedCollectionViewCell) {
        guard let indexPath = feateuredCollectionView.indexPath(for: cell),
              let products = featuredProductList?.1 else {
            return
        }

        let coffee = products[indexPath.row]
        DispatchQueue.global(qos: .background).async {
            UserManager.shared.addWishList(coffee: coffee) { isSuccess in
                DispatchQueue.main.async {
                    if isSuccess {
                        if let wishList = UserManager.shared.currentUser?.wishlist {
                            if wishList.contains(where: {$0.coffeeID == coffee.coffeeID}) {
                                cell.favoriteButton.tintColor = .red
                            } else {
                                cell.favoriteButton.tintColor = .lightGray
                            }
                        }
                    }
                }
            }
        }

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let products = featuredProductList?.1 {
            let coffee = products[indexPath.row]
            let detailVC = CoffeeDetailViewController()
            detailVC.coffee = coffee
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func didTapBasketButton(in cell: FeaturedCollectionViewCell) {
        guard let indexPath = feateuredCollectionView.indexPath(for: cell),
        let products = featuredProductList?.1 else {
            return
        }
        let coffee = products[indexPath.row]
        DispatchQueue.global(qos: .background).async {
            UserManager.shared.addCoffeeToBasket(coffee: coffee) { result in
                DispatchQueue.main.async {
                    if result {
                        self.showAlert(title: StringConstants.General.success, message: StringConstants.HomeView.productAddedToCart)
                    }else {
                        self.showAlert(title: StringConstants.General.error, message: StringConstants.Errors.unknown)
                    }
                }
            }
        }

        
    }
}
