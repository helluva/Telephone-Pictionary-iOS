//
//  CaptionWithImageViewController.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/26/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class CaptionWithImageViewController : UIViewController {
    
    
    //MARK: - Present
    
    static func present(in navigationController: UINavigationController?, withEncodedImage encodedImage: String) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "captionWithImage") as! CaptionWithImageViewController
        
        controller.encodedImage = encodedImage
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - View Setup
    
    var encodedImage = ""
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var phraseField: UITextField!
    @IBOutlet weak var imageViewBottom: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        
        encodedImage = encodedImage.replacingOccurrences(of: "~", with: "/")
        
        while encodedImage.lengthOfBytes(using: .utf8) % 4 != 0 {
            encodedImage += "="
        }
    
        guard let data = Data(base64Encoded: encodedImage, options: []) else { return }
        
        imageView.image = UIImage(data: data)
    }
    
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
                self.imageViewBottom.constant = unavailableSpace + 10
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    
    //MARK: - User Interaction
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        phraseField.resignFirstResponder()
    }
    
    @IBAction func commitGuess(_ sender: Any) {
            
        self.phraseField.resignFirstResponder()
        let phrase = self.phraseField.text ?? ""
        
        if phrase.isEmpty {
            let alert = UIAlertController(title: "You must make a guess", message: "The next player will draw what you write.", preferredStyle: .alert)
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
