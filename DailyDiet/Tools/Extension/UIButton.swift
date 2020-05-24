

import UIKit
import Spring

extension DesignableButton {
    static func makeButtonBlue(button: DesignableButton?){
        
        button?.setTitleColor(.white, for: .normal)
        button?.dropNormalShadow()
        button?.backgroundColor = .brandBlue
    }

    static func makeButtonActive(button: DesignableButton?){

        button?.setTitleColor(.white, for: .normal)
        button?.backgroundColor = .linenBackground
        button?.layer.borderWidth = 1
        button?.layer.borderColor = UIColor.brandOrange.cgColor
    }
    static func makeButtonGray(button: DesignableButton?){
        
        button?.shadowOpacity = 0
        button?.shadowOffsetY = 0
        button?.shadowRadius = 0
        button?.backgroundColor = .gray95
        button?.setTitleColor(.black, for: .normal)
    }
    
    static func makeButtonOrange(button: DesignableButton){
        button.backgroundColor = .brandOrange
    }
    

}

