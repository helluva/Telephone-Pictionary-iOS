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
    
    @IBOutlet weak var drawingView: ACEDrawingView!
    
    override func viewDidAppear(_ animated: Bool) {
        drawingView.delegate = self
    }
    
}
