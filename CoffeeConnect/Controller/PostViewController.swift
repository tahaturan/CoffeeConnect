//
//  SharePostViewController.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 21.10.2023.
//

import SnapKit
import UIKit

class PostViewController: UIViewController {
    // MARK: - Properties
    private let progressIndicator: CustomProgressIndicator = CustomProgressIndicator()
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFill
         imageView.clipsToBounds = true
         let cornerRadius: CGFloat = 15
         imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderColor = AppColors.special.color.withAlphaComponent(0.7).cgColor
         imageView.layer.borderWidth = 1.5
         imageView.backgroundColor = UIColor.systemGray5
       
         imageView.isUserInteractionEnabled = true
         return imageView
    }()

    private let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 10
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        return tv
    }()

    private lazy var shareButton: CustomButton = CustomButton(title: "Paylaş")

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        postImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }

}

// MARK: - Helpers

extension PostViewController {
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = StringConstants.General.newPost
        navigationController?.navigationBar.largeContentTitle = StringConstants.General.newPost
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 20),
        ]
        view.addSubview(postImageView)
        view.addSubview(descriptionTextView)
        view.addSubview(shareButton)
    }

    private func setupLayout() {
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }

        shareButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}

// MARK: - Actions

extension PostViewController {
    @objc private func imageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func shareButtonTapped() {
        progressIndicator.show(on: self.view)
        guard let image = postImageView.image, !descriptionTextView.text.isEmpty else {
            progressIndicator.hide()
            showAlert(title: StringConstants.General.error, message: StringConstants.Errors.imageOrDescMissing)
            return
        }
        if let user = UserManager.shared.currentUser {
            DataService.shared.saveNewPostToFirestore(userID: user.userID, image: image, description: descriptionTextView.text) { success in
                if success {
                    self.progressIndicator.hide()
                    self.showAlert(title: StringConstants.General.success, message: StringConstants.General.sharingPost)
                    self.descriptionTextView.text = ""
                    self.postImageView.image = nil
                } else {
                    self.progressIndicator.hide()
                    self.showAlert(title: StringConstants.General.error, message: StringConstants.Errors.postSharingFailed)
                }
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            postImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
