//
//  BlogViewController.swift
//  DailyDiet
//
//  Created by ali on 6/12/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring
import RxSwift

class BlogViewController: BaseViewController {
    
    
    @IBOutlet weak var blogTableView: UITableView!
    
    var APIDisposableBlogPost: Disposable!
    var APIDisposableDelete: Disposable!
    
    var blogList: [BlogValue] =  []
    var cellHeights: [CGFloat] = []
    var expandedCellHeights: [CGFloat] = []
    
    var shownCellHeight: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blogTableView.dataSource = self
        blogTableView.delegate = self
        loadBlogData()
    }
    
    
    
    func loadBlogData(){
        Log.i()
        blogTableView.tableHeaderView?.isHidden = false
        APIDisposableBlogPost?.dispose()
        APIDisposableBlogPost = nil
        APIDisposableBlogPost = API.blogList()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("blogList => onNext => \(response)")
                DispatchQueue.main.async {
                    self.blogTableView.tableHeaderView?.isHidden = true
                    self.blogList = []
                    for i in response.keys{
                        self.blogList.append(response[i]!)
                        self.cellHeights.append(0)
                        self.expandedCellHeights.append(0)
                        self.shownCellHeight.append(0)
                    }
                    self.blogTableView.reloadData()
                }
                
                //Login OK
            }, onError: { (error) in
                Log.e("blogList => onError => \(error) => \((error as NSError).domain)")
                let customError = (error as NSError)
                print(customError.userInfo)
                DispatchQueue.main.async {
                    self.blogTableView.tableHeaderView?.isHidden = true
                    self.blogList =  []
                    self.cellHeights = []
                    self.expandedCellHeights = []
                    self.shownCellHeight = []
                    self.blogTableView.reloadData()
                    DialogueHelper.showStatusBarErrorMessage(message: "Failed to load Blog Items")
                }
            })
    }
    
    override func doShakeFunction() {
        loadBlogData()
    }

    @IBAction func newPostButtondDidTap(_ sender: Any) {
        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: PostBlogItemViewController.instantiateFromStoryboardName(storyboardName: .Blog))
    }
}




extension BlogViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return blogList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlogItemTableViewCell", for: indexPath) as! BlogItemTableViewCell
            let cellData =  blogList[indexPath.row]
            
            
            cell.deleteButton.isHidden = true
            cell.moreButton.tag = indexPath.row
            
            cell.authorLabel.text = cellData.authorFullname
            cell.categoryLabel.text = cellData.category
            cell.titleLabel.text = cellData.title
            cell.summaryLabel.numberOfLines = 0
            cell.summaryLabel.text = cellData.summary
            cell.summaryLabel.sizeToFit()
            cell.summaryLabelHeight.constant = cell.summaryLabel.frame.height + 10
            
            cell.contentLabel.numberOfLines = 0
            cell.contentLabel.text = cellData.content
            cell.contentLabel.sizeToFit()
            cell.contentViewHeight.constant = cell.contentLabel.frame.height + 10
            
            expandedCellHeights[indexPath.row] = 220 + cell.summaryLabelHeight.constant +  cell.contentViewHeight.constant
            cellHeights[indexPath.row] = 220 + cell.summaryLabelHeight.constant
            shownCellHeight[indexPath.row] =  cell.isExpand ? expandedCellHeights[indexPath.row] : cellHeights[indexPath.row]
            
            if cell.isExpand {
                cell.contentLabel.text = cellData.content
                cell.contentLabel.sizeToFit()
                cell.contentViewHeight.constant = cell.contentLabel.frame.height
                cell.contentLabel.isHidden = false
                shownCellHeight[indexPath.row] = expandedCellHeights[indexPath.row]
            } else {
                cell.contentLabel.isHidden = true
                cell.contentViewHeight.constant = 0
                shownCellHeight[indexPath.row] = cellHeights[indexPath.row]
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return shownCellHeight[indexPath.row]
        }
        
        @IBAction func moreButtonDidTap(_ sender: DesignableButton) {
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = blogTableView.cellForRow(at: indexPath) as! BlogItemTableViewCell
            let cellData = blogList[indexPath.row]
            
            if cell.isExpand {
                cell.contentLabel.isHidden = true
                cell.contentViewHeight.constant = 0
                shownCellHeight[indexPath.row] = cellHeights[indexPath.row]
            } else {
                cell.contentLabel.text = cellData.content
                cell.contentLabel.sizeToFit()
                cell.contentViewHeight.constant = cell.contentLabel.frame.height
                cell.contentLabel.isHidden = false
                shownCellHeight[indexPath.row] = expandedCellHeights[indexPath.row]
            }
            cell.isExpand.toggle()
            blogTableView.beginUpdates()
            blogTableView.endUpdates()
        }
        
    }
