//
//  SearchViewController.swift
//  DailyDiet
//
//  Created by ali on 5/25/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: BaseViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchTextField: UITextField!
    
    var searchResult: [Food] = [
        Food(foodName: "fkjhkdhkhkdkhd", id: 412923, nutrition: Nutrition(calories: 200.56, carbs: 200, fats: 456, proteins: 235), primaryThumbnail: "https://images.eatthismuch.com/site_media/thmb/412923_simmyras_ddc29085-a105-4a41-b99c-66c4d070afab.png")
    ]
    var APIDisposeSearch: Disposable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
    }
    
    func doSearchAction(){
        if let text = searchTextField.text {
            if text.count >= 3{
                let searchText: String = searchTextField.text!
                
            }
        } else {
            DialogueHelper.showStatusBarErrorMessage(message: "Search field is empty")
        }
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        SegueHelper.popViewController(viewController: self)
    }
    
}


extension SearchViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(sender: UITextField) {
        Log.i()
        doSearchAction()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        doSearchAction()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doSearchAction()
        return true
    }
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchFoodCollectionViewCell", for: indexPath) as!  SearchFoodCollectionViewCell
        let cellData = searchResult[indexPath.row]
        
        cell.iconImageView.sd_setImage(with: URL(string: cellData.primaryThumbnail))
        cell.nameLabel.text = cellData.foodName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = searchResult[indexPath.row]
        let recepieVC = FoodRecipeViewController.instantiateFromStoryboardName(storyboardName: .Plan)
        recepieVC.foodID = cellData.id
        
        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: recepieVC)
    }
}

