//
//  SearchAndResultViewController.swift
//  VKWallParser
//
//  Created by Maxim Shirko on 29.07.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit

class SearchAndResultViewController: UIViewController{

    let WP = WallParser()
    private var numberOfPhotosInCell = 0
    private var photosArray = [String]()
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var parseButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .userInfoDictionaryDidUpdate, object: nil, queue: nil) { (notification) in
            self.tableView.reloadData()
        }
        setup()
        self.hideKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .userInfoDictionaryDidUpdate, object: nil)
    }
    
    @IBAction func parseButton(_ sender: Any) {
        self.tableView.scrollsToTop = true
        if validation(textField: idTextField){
            self.WP.fetch(api: VK_API.getWall(id: Int(self.idTextField.text!)!))
        }
    }
    
    private func setup(){
        idTextField.layer.cornerRadius = 5
        idTextField.layer.borderWidth = 1.5
        idTextField.layer.borderColor = UIColor.blue.cgColor
        parseButton.layer.cornerRadius = 5
        parseButton.layer.borderWidth = 1.5
        parseButton.layer.borderColor = UIColor.blue.cgColor
        parseButton.titleLabel?.textColor = UIColor.blue
    }
    
    //MARK: - Validation
    private func validation(textField: UITextField) -> Bool{
        guard let text = textField.text else {
            wrongValidation(textField: textField, message: "Input user ID")
            return false
        }
        guard text.count <= 10 else {
            wrongValidation(textField: textField, message: "Wrong user ID")
            return false
        }
        guard let _ = Int(text) else {
            wrongValidation(textField: textField, message: "Wrong user ID")
            return false
        }
        return true
    }
    
    private func wrongValidation(textField: UITextField, message: String){
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            textField.layer.borderColor = UIColor.blue.cgColor
        }
        alert.addAction(action)
        self.present(alert, animated: true) {
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }
}

//MARK: - TableView DataSourse & Delegate
extension SearchAndResultViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WP.wallObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell{
        
            let post = WP.wallObjects[indexPath.row]
            
            if let messageText = post.text{
                cell.messageTextLabel.text = messageText
            }
            if let user = WP.users[post.fromId!]{
                cell.fromLabel.text = "From: " + user.firstName! + " " + user.lastName!
            } else{
                cell.fromLabel.text = "From: " + String(describing: post.fromId!)
            }
            cell.likesLabel.text = "Likes: " + String(describing: post.likesCount!)
            cell.commentsLabel.text = "Comments: " + String(describing: post.commentsCount!)
            
            if let photos = post.photos{
                photosArray = post.photos!
                numberOfPhotosInCell = photos.count
            } else {
                photosArray.removeAll()
                numberOfPhotosInCell = 0
            }
            
            if self.numberOfPhotosInCell > 0{
                cell.photosCollectionView.heightAnchor.constraint(equalToConstant: 140.0).isActive = true
            } else{
                cell.photosCollectionView.heightAnchor.constraint(equalToConstant: 140.0).isActive = false
            }
            
            return cell
        } else {return UITableViewCell()}
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TableViewCell{
            cell.photosCollectionView.dataSource = self
            cell.photosCollectionView.delegate = self
            cell.photosCollectionView.reloadData()
        }
    }
}

//MARK: - CollectionView DataSourse & Delegate
extension SearchAndResultViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPhotosInCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        if let url = URL(string: self.photosArray[indexPath.row]){
                cell.photoImage.load(url: url)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: 130, height: 130)
        return size
    }
}

//MARK: - TextFieldDelegate
extension SearchAndResultViewController: UITextFieldDelegate{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(SearchAndResultViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
