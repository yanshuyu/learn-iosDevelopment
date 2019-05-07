//
//  NewRestaurantTableViewController.swift
//  foodieApp
//
//  Created by sy on 2019/4/24.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class NewRestaurantTableViewController: UITableViewController {
    
    enum FilledOption {
        case Completed
        case ReqiureName
        case ReqiureAddress
        case ReqiureCategory
    }
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields[0].becomeFirstResponder()
        for textField in self.textFields {
            textField.delegate = self
        }
        
//        descTextView.layer.borderWidth = 1
//        descTextView.layer.borderColor = UIColor.lightGray.cgColor
//        descTextView.layer.cornerRadius = 4
//        descTextView.layer.masksToBounds = true
        
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceController = UIAlertController(title: "", message: "Choose your image source", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
                // bring up camera
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.delegate = self
                    imagePickerController.sourceType = .camera
                    imagePickerController.allowsEditing = false
                    
                    self?.present(imagePickerController, animated: true, completion: nil)
                }
            }
            let imageLibaryAction = UIAlertAction(title: "Image Libary", style: .default) { [weak self] (action) in
                //bring up image libary
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.delegate = self
                    imagePickerController.allowsEditing = false
                    imagePickerController.sourceType = .photoLibrary
                    self?.present(imagePickerController, animated: true, completion: nil)
                }
                
            }
            let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
            
            photoSourceController.addAction(cameraAction)
            photoSourceController.addAction(imageLibaryAction)
            photoSourceController.addAction(cancleAction)
            self.present(photoSourceController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func onSaveButtonClick(_ sender: UIBarButtonItem) {
        let fillOption = self.checkNewFormFilledOption()
        var fillDesc: String? = nil
        switch fillOption {
        case .ReqiureName:
            fillDesc = "Name must not be empty!"
            break
        case .ReqiureAddress:
            fillDesc = "Address must not be empty!"
            break
        case .ReqiureCategory:
            fillDesc = "Type must not be empty!"
        case .Completed:
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Can't find AppDelegate of Foodie!")
            }
            let newRestaurant = RestaurantModel(context: appDelegate.persistentContainer.viewContext)
            newRestaurant.name = self.nameTextField.text
            newRestaurant.location = self.addressTextField.text
            newRestaurant.category = self.categoryTextField.text
            newRestaurant.phoneNumber = self.phoneTextField.text
            newRestaurant.detailDesc = self.descTextView.text
            newRestaurant.thumbnailImage = photoImageView.image?.pngData()
            newRestaurant.isMarked = false
            newRestaurant.rateImage = nil
            
            appDelegate.saveContext()
            
            self.dismiss(animated: true, completion: nil)
            break
        }
        
        if let fillDesc = fillDesc {
            let alertController = UIAlertController(title: "Uncompelete information", message: fillDesc, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func checkNewFormFilledOption() -> FilledOption {
        var fillOption  = FilledOption.Completed
        
        if self.nameTextField.text == nil || self.nameTextField.text!.isEmpty {
            fillOption = .ReqiureName
        }else if self.categoryTextField.text == nil || self.categoryTextField.text!.isEmpty {
            fillOption = .ReqiureCategory
        }else if self.addressTextField.text == nil || self.addressTextField.text!.isEmpty {
            fillOption = .ReqiureAddress
        }
        
        return fillOption
    }
    
}



extension NewRestaurantTableViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField =  self.view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return false
    }
}



extension NewRestaurantTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.photoImageView.image = selectedImage
            self.photoImageView.contentMode = .scaleAspectFill
            self.photoImageView.clipsToBounds = true
            self.dismiss(animated: true, completion: nil)
        }
        
        let leftConstraint = NSLayoutConstraint(item: self.photoImageView, attribute: .leading, relatedBy: .equal, toItem: self.photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leftConstraint.isActive = true
        
        let rightConstraint = NSLayoutConstraint(item: self.photoImageView, attribute: .trailing, relatedBy: .equal, toItem: self.photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        rightConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: self.photoImageView, attribute: .top, relatedBy: .equal, toItem: self.photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bouttomConstraint = NSLayoutConstraint(item: self.photoImageView, attribute: .bottom, relatedBy: .equal, toItem: self.photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bouttomConstraint.isActive = true
    }

}
