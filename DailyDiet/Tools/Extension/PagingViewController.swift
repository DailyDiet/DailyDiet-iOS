
import Foundation
import Parchment


extension PagingViewController {
    func setItemSize(width: CGFloat, height: CGFloat = 60.0, n: Int) {
        var itemWidth = (width - CGFloat(n-1) * self.menuItemSpacing)/CGFloat(n)
        
        if n < 3 {
            self.menuItemSpacing = 0
            itemWidth = (width - CGFloat(n-1) * self.menuItemSpacing)/CGFloat(n)
            self.menuItemSize = .fixed(width: itemWidth, height: 60)
        } else {
        if itemWidth < self.menuItemSize.width {
        self.menuItemSize = .selfSizing(estimatedWidth: itemWidth, height: height)
        } else {
            self.menuItemSize = .sizeToFit(minWidth: itemWidth, height: height)
        }
        }
    }
}
