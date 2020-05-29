
import UIKit

extension UIView {
  func round(corners: CACornerMask, radius: CGFloat) {
      layer.cornerRadius = radius
      layer.maskedCorners = corners
  }
    func dropNormalShadow() {
        Log.i()

        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -2, height: 2)
        layer.shadowRadius = 2.5
    }
    

    func makeRound() {
        Log.i()

        layer.cornerRadius = layer.frame.height / 2
        layer.masksToBounds = true
    }

    func makeBottomRound(width: Int = 5, height: Int = 5) {
        Log.i()

        let maskPath = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: width, height: height))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func makeTopRound(width: Int = 5, height: Int = 5) {
        Log.i()

        let maskPath = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: width, height: height))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    func addTopBorder(borderColor: UIColor, borderHeight: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: borderHeight)
        self.layer.addSublayer(border)
    }

    func constrainCentered(_ subview: UIView) {

      subview.translatesAutoresizingMaskIntoConstraints = false

      let verticalContraint = NSLayoutConstraint(
        item: subview,
        attribute: .centerY,
        relatedBy: .equal,
        toItem: self,
        attribute: .centerY,
        multiplier: 1.0,
        constant: 0)

      let horizontalContraint = NSLayoutConstraint(
        item: subview,
        attribute: .centerX,
        relatedBy: .equal,
        toItem: self,
        attribute: .centerX,
        multiplier: 1.0,
        constant: 0)

      let heightContraint = NSLayoutConstraint(
        item: subview,
        attribute: .height,
        relatedBy: .equal,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1.0,
        constant: subview.frame.height)

      let widthContraint = NSLayoutConstraint(
        item: subview,
        attribute: .width,
        relatedBy: .equal,
        toItem: nil,
        attribute: .notAnAttribute,
        multiplier: 1.0,
        constant: subview.frame.width)

      addConstraints([
        horizontalContraint,
        verticalContraint,
        heightContraint,
        widthContraint])

    }


    func constrainToEdges(_ subview: UIView) {

      subview.translatesAutoresizingMaskIntoConstraints = false

      let topContraint = NSLayoutConstraint(
        item: subview,
        attribute: .top,
        relatedBy: .equal,
        toItem: self,
        attribute: .top,
        multiplier: 1.0,
        constant: 0)

      let bottomConstraint = NSLayoutConstraint(
        item: subview,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: self,
        attribute: .bottom,
        multiplier: 1.0,
        constant: 0)

      let leadingContraint = NSLayoutConstraint(
        item: subview,
        attribute: .leading,
        relatedBy: .equal,
        toItem: self,
        attribute: .leading,
        multiplier: 1.0,
        constant: 0)

      let trailingContraint = NSLayoutConstraint(
        item: subview,
        attribute: .trailing,
        relatedBy: .equal,
        toItem: self,
        attribute: .trailing,
        multiplier: 1.0,
        constant: 0)

      addConstraints([
        topContraint,
        bottomConstraint,
        leadingContraint,
        trailingContraint])
    }

}
