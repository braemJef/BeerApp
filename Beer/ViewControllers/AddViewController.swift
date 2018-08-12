//
//  AddViewController.swift
//  Beer
//
//  Created by Jef Braem on 07/08/2018.
//  Copyright © 2018 Jef Braem. All rights reserved.
//

import UIKit
import RealmSwift
import Photos

class AddViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var beerNameTextField: UITextField!
    @IBOutlet weak var beerBreweryTextField: UITextField!
    @IBOutlet weak var beerAlcoholTextField: UITextField!
    @IBOutlet weak var beerScoreDisplay: UILabel!
    @IBOutlet weak var beerScoreStepper: UIStepper!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    var editedBeer: Beer? = nil
    let realm = try! Realm()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerAlcoholTextField.delegate = self
        
        if editedBeer != nil {
            
            // Part to retrieve image from app files
            // This part was done with help from this blog post: https://appsandbiscuits.com/take-save-and-retrieve-a-photo-ios-13-4312f96793ff
            let fileManager = FileManager.default
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent((editedBeer?.ImagePath)!)
            if fileManager.fileExists(atPath: imagePath){
                imageView.image = UIImage(contentsOfFile: imagePath)
                addPhotoButton.setTitle("", for: .normal)
            }
            
            navigationBar.title = "Edit"
            beerNameTextField.text = editedBeer?.Name
            beerBreweryTextField.text = editedBeer?.Brewery
            beerAlcoholTextField.text = editedBeer?.Alcohol
            beerScoreStepper.value = (editedBeer?.Score)!
            
        } else {
            navigationBar.title = "Add"
        }
        beerScoreDisplay.text = String(repeating: "🍺", count: Int(beerScoreStepper.value))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // All code concerning taking or selecting pictures
    @IBAction func addPhotoAction(_ sender: Any) {
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: "Photo", message: "Choose a method", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (action: UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            addPhotoButton.setTitle("", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Function to save image to app documents
    // This part was done with help from this blog post: https://appsandbiscuits.com/take-save-and-retrieve-a-photo-ios-13-4312f96793ff
    func saveImage(imageName: String) {
        if let image = imageView.image {
            // Initialize a fileManager
            let fileManager = FileManager.default
            
            // Construct our image path
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
            
            if fileManager.fileExists(atPath: imagePath) {
                try! fileManager.removeItem(atPath: imagePath)
            }
            
            // Convert our taken image to data that the phone can save
            let data = UIImagePNGRepresentation(image)
            
            // Save the image
            fileManager.createFile(atPath: imagePath, contents: data, attributes: nil)
        }
    }
    
    // Handle score change
    @IBAction func beerScoreAction(_ sender: Any) {
        beerScoreDisplay.text = String(repeating: "🍺", count: Int(beerScoreStepper.value))
    }
    
    // Save the beer
    @IBAction func saveButtonAction(_ sender: Any) {
        if editedBeer != nil {
            try! realm.write {
                editedBeer?.Name = beerNameTextField.text!
                editedBeer?.Brewery = beerBreweryTextField.text!
                editedBeer?.Alcohol = beerAlcoholTextField.text!
                editedBeer?.Score = beerScoreStepper.value
                saveImage(imageName: (editedBeer?.ImagePath)!)
            }
        } else {
            let beer = Beer()
            let imagePathName = String(Date().timeIntervalSinceNow)
            beer.Name = beerNameTextField.text!
            beer.Brewery = beerBreweryTextField.text!
            beer.Alcohol = beerAlcoholTextField.text!
            beer.Score = beerScoreStepper.value
            beer.ImagePath = imagePathName
            saveImage(imageName: imagePathName)
            try! realm.write {
                realm.add(beer)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // Alcohol number handler
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        var fullText = textField.text!
        fullText.append(string)
        fullText = fullText.replacingOccurrences(of: ",", with: ".")
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
        let characterSet = CharacterSet(charactersIn: fullText)
        let stringIsValid = allowedCharacters.isSuperset(of: characterSet)
        
        if !stringIsValid {
            return false
        }
        if fullText.prefix(1) == "." {
            textField.text = "0." + fullText.replacingOccurrences(of: ".", with: "")
            return false
        }
        let amount = fullText.components(separatedBy: ".")
        if amount.count > 2 {
            return false
        }
        if fullText.count == 2 {
            if fullText.prefix(1) == "0" {
                fullText = String(fullText.suffix(1))
                textField.text = fullText
                return false
            }
        }
        
        textField.text = fullText
        return false
    }
}

