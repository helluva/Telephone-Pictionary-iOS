//
//  DrawViewController.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/25/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class DrawViewController : UIViewController, JotViewControllerDelegate {
    
    var jot: JotViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.jot = JotViewController()
        self.jot.delegate = self
        
        self.addChildViewController(self.jot)
        self.view.addSubview(self.jot.view)
        self.jot.didMove(toParentViewController: self)
        self.jot.view.frame = self.view.frame
        
        self.jot.state = .drawing
        self.jot.drawingConstantStrokeWidth = true
        self.jot.drawingStrokeWidth = 4.0
        
    }
    
}
