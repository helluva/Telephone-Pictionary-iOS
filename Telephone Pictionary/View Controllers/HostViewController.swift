//
//  HostViewController.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/25/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class HostViewController : UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var hostNameField: UITextField!
    @IBOutlet weak var gameNameField: UITextField!
    
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
    
    @IBAction func yourNameNext(_ sender: Any) {
        self.gameNameField.becomeFirstResponder()
    }
    
    @IBAction func gameNameDone(_ sender: Any) {
        self.createGame(sender)
    }
    
    @IBAction func createGame(_ sender: Any) {
        
        self.gameNameField.resignFirstResponder()
        self.gameNameField.resignFirstResponder()
        
        let hostName = hostNameField.text!
        let gameName = gameNameField.text!
        
        if hostName.isEmpty {
            let alert = UIAlertController(title: "Please add your name", message: "This is how other players will know who you are.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if gameName.isEmpty {
            let alert = UIAlertController(title: "Please add a name for your new Game", message: "This is how other players will know which game to join", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        ApplicationState.state.sendMessage("hostGame:\(gameName),\(hostName)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
            PlayersViewController.present(in: self.navigationController!, playerIsHost: true)
        })
        
        
    }
    
    
}
