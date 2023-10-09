//
//  PhotoPickerManager.swift
//  CoffeeConnect
//
//  Created by Taha Turan on 9.10.2023.
//

import UIKit

protocol PhotoPickerManagerDelegate: AnyObject {
    func didPickImage(_ image: UIImage)
}

class PhotoPickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var picker = UIImagePickerController()
    weak var delegate: PhotoPickerManagerDelegate?
    var viewController: UIViewController?
    
    func presentPhotoPicker(on viewController: UIViewController)  {
        self.viewController = viewController
        picker.delegate = self
        picker.allowsEditing = true
        viewController.present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            delegate?.didPickImage(editedImage)
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            delegate?.didPickImage(originalImage)
        }
        viewController?.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController?.dismiss(animated: true)
    }
}
