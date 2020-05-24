import BRYXBanner
import Foundation

class DialogueHelper {

    

    static func showStatusBarErrorMessage(errorMessageStr: String, _ color: UIColor = .systemOrange)  {
    Log.i()
        DispatchQueue.main.async {
            let banner = Banner(title: "", subtitle: errorMessageStr, image: nil, backgroundColor: color)
            banner.titleLabel.font = .IRANSansMobile_Bold(size: 15)
            banner.preferredStatusBarStyle = .lightContent
            banner.detailLabel.textAlignment = .center
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        }
    }
    
    static func showNetworkErrorBanner() {
        Log.i()
        DispatchQueue.main.async {
        let banner = Banner(title: "خطا در اتصال به اینترنت", subtitle: "لطفا اتصال خود به اینترنت را بررسی کنید.", image: UIImage(named: "NetworkProblem"), backgroundColor: .systemOrange)
            banner.titleLabel.font = .IRANSansMobile_Bold(size: 15)
        banner.titleLabel.textAlignment = .center
        banner.detailLabel.textAlignment = .center
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    }
}
