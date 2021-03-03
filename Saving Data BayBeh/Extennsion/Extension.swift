//
//  Extension.swift
//  Saving Data BayBeh
//
//  Created by Kartheek Repakula on 02/03/21.
//  Copyright © 2021 Kyle Lee. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK:SHOW TOAST
    func showToast(message : String) {
        
        let message = message
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        self.present(alert, animated: true)
        
        let duration: Double = 2
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
}

extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)) ~= self
    }
    
}

