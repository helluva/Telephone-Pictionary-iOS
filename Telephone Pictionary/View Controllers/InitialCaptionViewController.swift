//
//  InitialCaptionViewController.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/26/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

//
//  HostViewController.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/25/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class InitialCaptionViewController : UIViewController {
    
    
    //MARK: - Presentation
    
    static func present(in navigationController: UINavigationController?) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "initialCaption") as! InitialCaptionViewController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - View Setup
    
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    @IBOutlet weak var phraseField: UITextField!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardChanged(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    func keyboardChanged(notification: Notification) {
        let info = notification.userInfo as? [String : Any]
        if let keyboardSize = (info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (info?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            
            let keyboardTop = keyboardSize.origin.y
            let unavailableSpace = UIScreen.main.bounds.height - keyboardTop
            
            
            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
                self.contentViewBottom.constant = unavailableSpace
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func commitPhrase(_ sender: Any) {
        
        self.phraseField.resignFirstResponder()
        let phrase = self.phraseField.text ?? ""
        
        if phrase.isEmpty {
            let alert = UIAlertController(title: "You must type a phrase", message: "The next player will draw what you write.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        ApplicationState.state.sendMessage("provideCaption:\(phrase)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
            WaitingViewController.present(in: self.navigationController)
        })
        
        
    }
    
}

