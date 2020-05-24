
import UIKit
extension UISegmentedControl {

    func removeBorder() {
        Log.i()

        tintColor = UIColor.clear
        backgroundColor = UIColor.clear

        setTitleTextAttributes([NSAttributedString.Key.font: UIFont.IRANSansMobile()], for: .normal)
        setTitleTextAttributes([NSAttributedString.Key.font: UIFont.IRANSansMobile_Bold()], for: .normal)

        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = UIColor.clear
        }

    }

    func setupSegment() {
        Log.i()

        removeBorder()
        let segmentUnderlineWidth: CGFloat = bounds.width
        let segmentUnderlineHeight: CGFloat = 5
        let segmentUnderlineXPosition = bounds.minX
        let segmentUnderLineYPosition = bounds.size.height - 1.0
        let segmentUnderlineFrame = CGRect(x: segmentUnderlineXPosition, y: segmentUnderLineYPosition, width: segmentUnderlineWidth, height: segmentUnderlineHeight)
        let segmentUnderline = UIView(frame: segmentUnderlineFrame)
        segmentUnderline.backgroundColor = UIColor.clear

        addSubview(segmentUnderline)
        addUnderlineForSelectedSegment()
    }

    func addUnderlineForSelectedSegment() {
        Log.i()

        let underlineWidth: CGFloat = bounds.size.width / CGFloat(numberOfSegments)
        let underlineHeight: CGFloat = 5
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)

        let underline = UIView(frame: underlineFrame)
//        underline.makeTopRound()
        underline.round(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 15)
        underline.backgroundColor = .brandOrange
        underline.tag = 1
        addSubview(underline)


    }

    func changeUnderlinePosition() {
        Log.i()

        guard let underline = viewWithTag(1) else { return }
        let underlineFinalXPosition = (bounds.width / CGFloat(numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.frame.origin.x = underlineFinalXPosition

    }
}
