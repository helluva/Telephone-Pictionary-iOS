//
//  WaitingViewController.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/26/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class WaitingViewController : UIViewController {
    
    
    //MARK: - Presentation
    
    static func present(in navigationController: UINavigationController?) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "waiting") as! WaitingViewController
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - Listeners
    
    override func viewWillAppear(_ animated: Bool) {
        
        ApplicationState.state.registerListener(forNodeMethod: "nextCaption", named: "waitingForCaption", callback: { nextCaption in
            DrawViewController.present(in: self.navigationController!, withPhrase: nextCaption)
        })
        
        ApplicationState.state.registerListener(forNodeMethod: "nextImage", named: "waitingForImage", callback: { encodedImage in
            CaptionWithImageViewController.present(in: self.navigationController, withEncodedImage: encodedImage)
        })
        
    }
    
}
