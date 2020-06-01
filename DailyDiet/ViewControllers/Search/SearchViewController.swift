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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    
    var searchResult: [Result] = []
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var APIDisposeSearch: Disposable!
    var count: Int = 10
    var total: Int = 10
    var isLoadingMore: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectRow(at: selectedIndexPath, animated: false)
    }
    
    func doSearchAction(page: Int, count: Int = 10){
        if let text = searchTextField.text {
            if text.count >= 3{
                let searchText: String = searchTextField.text!
                APIDisposeSearch?.dispose()
                APIDisposeSearch = nil
                APIDisposeSearch = API.search(query: searchText, page: page, perPage: count)
                    .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                    .subscribe(onNext: { (response) in
                        Log.i("search => onNext => \(response)")
                        DispatchQueue.main.async {
                            self.searchResult += response.results
                            self.total = response.totalResultsCount
                            self.isLoadingMore = false
                            self.tableView.reloadData()
                        }
                        
                    }, onError: { (error) in
                        Log.e("search => onError => \(error) => \((error as NSError).domain)")
                        let customError = (error as NSError)
                        self.isLoadingMore = false
                        
                        
                        if let error = (customError.userInfo["error"] as? String) {
                            if error == "" {
                                DialogueHelper.showStatusBarErrorMessage(message: "You should enter search text")
                            } else {
                                DialogueHelper.showStatusBarErrorMessage(message: "Failed to search")
                            }
                        }
                        
                    })
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
        searchResult = []
        doSearchAction(page: 1)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFoodTableViewCell", for: indexPath) as!  SearchFoodTableViewCell
        let cellData = searchResult[indexPath.row]
        
        cell.iconImageView.sd_setImage(with: URL(string: cellData.thumbnail))
        cell.nameLabel.text = cellData.title
        
        cell.proteinLabel.text = "\(cellData.nutrition.protein)"
        cell.calorieLabel.text = "\(cellData.nutrition.calories)"
        //        cell.fiberLabel.text = "\(cellData.nutrition.carbs)"
        cell.fatLabel.text = "\(cellData.nutrition.fat)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = searchResult[indexPath.row]
        selectedIndexPath = indexPath
        let recepieVC = FoodRecipeViewController.instantiateFromStoryboardName(storyboardName: .Plan)
        recepieVC.foodID = cellData.id
        
        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: recepieVC)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == searchResult.count - 1 {
            if searchResult.count < total && !isLoadingMore {
                doSearchAction(page: Int(searchResult.count / 10))
                isLoadingMore = true
            }
        }
    }
}

