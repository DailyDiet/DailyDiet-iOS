
import Foundation
import UIKit
import Parchment

class MainPagingViewController: PagingViewController {
    
    public func configure(backgroundColor: UIColor = UIColor(red: 196/255, green: 237/255, blue: 244/255, alpha: 1), indicatorColor: UIColor) {
        loadViewIfNeeded()
        self.includeSafeAreaInsets = true
        self.indicatorColor = indicatorColor
        self.backgroundColor = backgroundColor
        self.selectedBackgroundColor = backgroundColor
        self.menuBackgroundColor = backgroundColor
        self.menuInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.selectedTextColor = .black
        self.reloadMenu()
        self.textColor = .black
    }
    
}
