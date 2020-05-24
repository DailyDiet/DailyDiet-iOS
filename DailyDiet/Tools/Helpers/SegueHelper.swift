

import UIKit

class SegueHelper: NSObject {

    class func pushViewController(sourceViewController: UIViewController, destinationViewController: UIViewController) {
        Log.i("sourceViewController => \(sourceViewController.restorationIdentifier ?? "Nil") ,destinationViewController => \(destinationViewController.restorationIdentifier ?? "Nil")")

        sourceViewController.navigationController?.pushViewController(destinationViewController, animated: true)
    }

    class func pushViewControllerWithoutAnimation(sourceViewController: UIViewController, destinationViewController: UIViewController) {
        Log.i("sourceViewController => \(sourceViewController) ,destinationViewController => \(destinationViewController)")

        sourceViewController.navigationController?.pushViewController(destinationViewController, animated: false)
    }

    class func presentViewController(sourceViewController: UIViewController, destinationViewController: UIViewController) {
        Log.i("sourceViewController => \(sourceViewController) ,destinationViewController => \(destinationViewController)")
        
        
        sourceViewController.present(destinationViewController, animated: true, completion: nil)
        
    }

    class func popViewController(viewController: UIViewController) {
        Log.i("viewController => \(viewController)")

        viewController.navigationController?.popViewController(animated: true)
    }

}
