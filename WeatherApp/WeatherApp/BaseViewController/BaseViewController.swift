//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Hassan Qureshi on 8/15/20.
//  Copyright © 2020 hassan qureshi. All rights reserved.
//

import UIKit
import Toast_Swift

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- SHOW Activity Indicator
    
    func showActivityView(){
        self.view.isUserInteractionEnabled = false
        self.view.makeToastActivity(.center)
    }
    
    func hideActivityView(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.view.hideToastActivity()
        }
    }

}
