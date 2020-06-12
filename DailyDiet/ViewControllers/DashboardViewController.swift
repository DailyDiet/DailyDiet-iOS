//
//  DashboardViewController.swift
//  DailyDiet
//
//  Created by ali on 5/25/20.
//  Copyright © 2020 Alireza. All rights reserved.
//

import UIKit
import Spring
import RxSwift

enum PresentView{
    case SignIn, SignUp, ChangePassword
}

protocol LoginStatusDelegate {
    func updateLoginStatus()
}

protocol PresentViewDelegate {
    func showView(viewType: PresentView)
}

class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var myPostsTableView: UITableView!
    @IBOutlet weak var profileStackView: UIStackView!
    @IBOutlet var modifyPasswordButton: DesignableButton!
    @IBOutlet var signInButton: DesignableButton!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    static var presentDelegate: PresentViewDelegate!
    static var loginDelegate: LoginStatusDelegate!
    var APIDisposableUserInfo: Disposable!
    var APIDisposableSignOut: Disposable!
    var APIDisposableMyPosts: Disposable!
    var APIDisposableDelete: Disposable!
    
    var myPostList: [MyBlogItemListValue] =  []
    var cellHeights: [CGFloat] = []
    var expandedCellHeights: [CGFloat] = []
    
    var shownCellHeight: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DashboardViewController.presentDelegate = self
        DashboardViewController.loginDelegate = self
        
        myPostsTableView.delegate = self
        myPostsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
        
        if StoringData.isLoggedIn {
            self.myPostsTableView.tableHeaderView?.isHidden = false
            APIDisposableMyPosts?.dispose()
            APIDisposableMyPosts = nil
            APIDisposableMyPosts = API.myBlogPosts()
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onNext: { (response) in
                    Log.i("myBlogPosts => onNext => \(response)")
                    DispatchQueue.main.async {
                        self.myPostsTableView.tableHeaderView?.isHidden = true
                        self.myPostList = []
                        for key in response.keys {
                            var x = response[key]
                            x?.id = key
                            self.myPostList.append(x!)
                            self.cellHeights.append(0)
                            self.expandedCellHeights.append(0)
                            self.shownCellHeight.append(0)
                        }
                        self.myPostsTableView.reloadData()
                    }
                    
                    //Login OK
                }, onError: { (error) in
                    Log.e("myBlogPosts => onError => \(error) => \((error as NSError).domain)")
                    let customError = (error as NSError)
                    print(customError.userInfo)
                    DispatchQueue.main.async {
                        self.myPostsTableView.tableHeaderView?.isHidden = true
                        self.cellHeights = []
                        self.expandedCellHeights = []
                        self.shownCellHeight = []
                        self.myPostsTableView.reloadData()
                    }
                })
        }
    }
    
    override func configureViews() {
        
        if StoringData.isLoggedIn {
            self.signInButton.setTitle("Sign out", for: .normal)

            self.APIDisposableUserInfo?.dispose()
            self.APIDisposableUserInfo = nil
            self.APIDisposableUserInfo = API.userInfo()
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .subscribe(onNext: { (response) in
                    Log.i("userInfo => onNext => \(response)")
                    DispatchQueue.main.async {
                        if response.confirmed == "True" {
                            ValueKeeper.User = UserInfo(confirmed: response.confirmed, email: response.email, fullName: response.fullName)
                            
                            self.modifyPasswordButton.isHidden = false
                            self.profileStackView.isHidden = false
                            self.fullNameLabel.text = response.fullName
                            self.emailLabel.text = response.email
                            
                        } else if response.confirmed == "False"{
                            StoringData.token = ""
                            StoringData.refreshToken = ""
                            StoringData.isLoggedIn = false
                            DialogueHelper.showStatusBarErrorMessage(message: "Confirm your account with the link we sent to your email.")
                            
                            
                        }
                    }
                    
                    //Login OK
                }, onError: { (error) in
                    Log.e("userInfo => onError => \(error) => \((error as NSError).domain)")
                    let customError = (error as NSError)
                    print(customError.userInfo)
                    DispatchQueue.main.async {
                        self.profileStackView.isHidden = true
                        self.modifyPasswordButton.isHidden = true
                        self.signInButton.setTitle("Sign in", for: .normal)
                        StoringData.token = ""
                        StoringData.refreshToken = ""
                        StoringData.isLoggedIn = false
                        DialogueHelper.showStatusBarErrorMessage(message: "Failed to sign in")
                    }
                })
        } else {
            profileStackView.isHidden = true
            modifyPasswordButton.isHidden = true
            myPostsTableView.isHidden = true
            myPostList = []
            signInButton.setTitle("Sign in", for: .normal)
        }
    }
    
}

extension DashboardViewController {
    
    func doSignOutAction(){
        Log.i()
        self.signInButton.isEnabled = false
        self.signInButton.borderColor = .darkGray
        self.signInButton.setTitleColor(.darkGray, for: .normal)
        
        APIDisposableSignOut?.dispose()
        APIDisposableSignOut = nil
        APIDisposableSignOut = API.signOut()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("signOut => onNext => \(response)")
                DispatchQueue.main.async {
                    self.signInButton.isEnabled = true
                    self.signInButton.borderColor = .brandBlue
                    self.signInButton.setTitleColor(.brandBlue, for: .normal)
                    StoringData.isLoggedIn = false
                    StoringData.password = ""
                    StoringData.email = ""
                    StoringData.token = ""
                    StoringData.refreshToken = ""
                    TabBarViewController.changeTabBarDelegate.changeTabBarIndex(index: 1)
                }
                
                //Login OK
            }, onError: { (error) in
                Log.e("userInfo => onError => \(error) => \((error as NSError).domain)")
                let customError = (error as NSError)
                print(customError.userInfo)
                DispatchQueue.main.async {
                    self.signInButton.isEnabled = true
                    self.signInButton.borderColor = .brandBlue
                    self.signInButton.backgroundColor = .white
                    DialogueHelper.showStatusBarErrorMessage(message: "Failed to sign out")
                }
            })
    }
    
    func doSignInAction(){
        Log.i()
        performSegue(withIdentifier: "SignInSegue", sender: self)
    }
    
    @IBAction func signInButtonDidTap(_ sender: Any) {
        if StoringData.isLoggedIn {
            doSignOutAction()
        } else {
            doSignInAction()
        }
    }
    
    @IBAction func aboutUsButtonDidTap(_ sender: Any) {
        SegueHelper.pushViewController(sourceViewController: self, destinationViewController: AboutUsViewController.instantiateFromStoryboardName(storyboardName: .UserAction))
    }
}

extension DashboardViewController: LoginStatusDelegate {
    func
        updateLoginStatus() {
        configureViews()
        viewWillAppear(false)
    }
}

extension DashboardViewController: PresentViewDelegate {
    func showView(viewType: PresentView) {
        switch viewType {
        case .ChangePassword:
            let changePasswordVC = ChangePasswordViewController.instantiateFromStoryboardName(storyboardName: .UserAction)
            changePasswordVC.modalPresentationStyle = .fullScreen
            SegueHelper.presentViewController(sourceViewController: self, destinationViewController: changePasswordVC)
        case .SignIn:
            performSegue(withIdentifier: "SignInSegue", sender: self)
        case .SignUp:
            performSegue(withIdentifier: "SignUpSegue", sender: self)
        }
    }
}


extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogItemTableViewCell", for: indexPath) as! BlogItemTableViewCell
        let cellData =  myPostList[indexPath.row]
        
        
        cell.deleteButton.tag = indexPath.row
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
        
        expandedCellHeights[indexPath.row] = 250 + cell.summaryLabelHeight.constant +  cell.contentViewHeight.constant
        cellHeights[indexPath.row] = 220 + cell.summaryLabelHeight.constant + 30
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
    
    
    @IBAction func deleteButtonDidTap(_ sender: DesignableButton) {
        sender.isEnabled = false
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cellData = myPostList[indexPath.row]
        
        APIDisposableDelete?.dispose()
        APIDisposableDelete = nil
        APIDisposableDelete = API.deleteBlogItem(itemID: cellData.id!)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (response) in
                Log.i("deleteBlogItem => onNext => \(response)")
                DispatchQueue.main.async {
                    sender.isEnabled = true
                    self.myPostList.remove(at: indexPath.row)
                    self.myPostsTableView.beginUpdates()
                    self.myPostsTableView.endUpdates()
                }
                
                //Login OK
            }, onError: { (error) in
                Log.e("deleteBlogItem => onError => \(error) => \((error as NSError).domain)")
                let customError = (error as NSError)
                print(customError.userInfo)
                DispatchQueue.main.async {
                    sender.isEnabled = true
                }
            })
    }
    
    @IBAction func moreButtonDidTap(_ sender: DesignableButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = myPostsTableView.cellForRow(at: indexPath) as! BlogItemTableViewCell
        let cellData = myPostList[indexPath.row]
        
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
        myPostsTableView.beginUpdates()
        myPostsTableView.endUpdates()
    }
    
}
