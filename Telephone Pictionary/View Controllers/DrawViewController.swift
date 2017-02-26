//
//  DrawViewController.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/25/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit
import ACEDrawingView

class DrawViewController : UIViewController, ACEDrawingViewDelegate {
    
    
    //MARK: - Presentation
    
    static func present(in navigationController: UINavigationController, withPhrase phrase: String) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "draw") as! DrawViewController
        controller.phrase = phrase
        
        navigationController.pushViewController(controller, animated: true)
    }
        
    
    //MARK: - Setup
    
    var phrase: String = ""
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var drawingView: ACEDrawingView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.drawingView.delegate = self
        self.drawingView.lineWidth = 2.0
        self.descriptionLabel.text = self.phrase
        
        self.drawingView.layer.borderColor = UIColor.gray.cgColor
        self.drawingView.layer.borderWidth = 0.5
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func donePressed(_ sender: Any) {
        
        let image = self.drawingView.asImage
        let data = UIImageJPEGRepresentation(image, 0.8)
        let base64 = data!.base64EncodedData()
        let string = String(data: base64, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "/", with: "~")
        
        ApplicationState.state.sendMessage("provideImage:\(string)")
        WaitingViewController.present(in: self.navigationController)
        
    }
    
}

extension UIView {
    
    var asImage: UIImage {
        let previousAlpha = self.alpha
        self.alpha = 1.0
        
        let deviceScale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, deviceScale)
        
        let context = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        self.alpha = previousAlpha
        return image
    }
    
}
