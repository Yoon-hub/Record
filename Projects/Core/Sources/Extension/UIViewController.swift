//
//  UIViewController.swift
//  Core
//
//  Created by 윤제 on 7/18/24.
//

import UIKit

extension UIViewController {
    public func showAlert(
        title: String?,
        message: String?
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okButton = UIAlertAction(
            title: "확인",
            style: .default
        )
        
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}
