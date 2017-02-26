//
//  ViewController.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/25/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApplicationState.state.sendMessage("hostGame:ios,ios-test")
        
        ApplicationState.state.sendMessage("requestListOfGames") { response in
            print(response)
        }
    }


}

