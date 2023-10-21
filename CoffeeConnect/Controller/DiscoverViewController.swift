//
//  DiscoverViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 18.10.2023.
//

import SnapKit
import UIKit

class DiscoverViewController: UIViewController {
    // MARK: - Properties

    var allUsersWithPosts: [(user: UserModel, posts: [PostModel])] = []
    private lazy var navBarProfileImage: UIBarButtonItem = {
        let profileImageView = UIImageView()
        DispatchQueue.main.async {
            if let user = UserManager.shared.currentUser {
                ImageLoader.shared.loadImage(into: profileImageView, from: user.profileImageURL)
            }
        }
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true

        let containerView = UIView()
        containerView.addSubview(profileImageView)

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
            make.bottom.equalTo(containerView.snp.bottom)
            make.left.equalTo(containerView.snp.left)
            make.right.equalTo(containerView.snp.right)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileImage))
        containerView.addGestureRecognizer(tapGesture)

        return UIBarButtonItem(customView: containerView)
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 330
        tableView.separatorStyle = .none
        tableView.register(DiscoverTableViewCell.self, forCellReuseIdentifier: StringConstants.CellIDs.discoverCellID)
        return tableView
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        print("okey")
    }
}

// MARK: - Helpers

extension DiscoverViewController {
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        configureNaviagtionBar()
    }

    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func fetchData() {
        DataService.shared.listenToAllUsersWithPosts { result in
            switch result {
            case let .success(data):
                self.allUsersWithPosts = data.map { userWithPosts in
                    let sortedPosts = userWithPosts.posts.sorted(by: { $0.creationDate > $1.creationDate })
                    return (user: userWithPosts.user, posts: sortedPosts)
                }
                self.tableView.reloadData()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }


    private func configureNaviagtionBar() {
        navigationItem.title = StringConstants.MainTabbar.discover
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]
        navigationItem.rightBarButtonItem = navBarProfileImage
    }
}

// MARK: - Selector

extension DiscoverViewController {
    @objc private func handleProfileImage() {
        // TODO: buton islevi
    }
}

// MARK: - UITableView Delegate/DataSource

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsersWithPosts[section].posts.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return allUsersWithPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.CellIDs.discoverCellID, for: indexPath) as! DiscoverTableViewCell
        let post = allUsersWithPosts[indexPath.section].posts[indexPath.row]
        let user = allUsersWithPosts[indexPath.section].user
       
            cell.configureCell(post: post, user: user)
        
        return cell
    }
}
