//
//  Alert+UIViewController.swift
//  SmartClickAITest
//
//  Created by Sos Avetyan on 5/22/20.
//  Copyright © 2020 Sos Avetyan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(title: String?, textString: String) {
        let alertController = UIAlertController(title: title ?? "", message: textString, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { _ in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showSuccessAlert(textString: String) {
        let alertController = UIAlertController(title:"Condratulations", message: textString, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func askQuestionAlert(title: String?, textString: String, _ success: @escaping () -> Void) {
        let alertController = UIAlertController(title: title ?? "", message: textString, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "YES", style: .default, handler: { _ in
            
            success()
        }))
        alertController.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { _ in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
