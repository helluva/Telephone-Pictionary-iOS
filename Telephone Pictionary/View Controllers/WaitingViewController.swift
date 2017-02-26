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
            let image = self.base64StringToImage(encodedImage)
            CaptionWithImageViewController.present(in: self.navigationController, withImage: image)
        })
        
        ApplicationState.state.registerListener(forNodeMethod: "gameEnded", named: "gameOver", callback: { _ in
            
            //load review of all game content
            var content = [(roundNumber: Int, type: DataType, data: Any)]()
            
            ApplicationState.state.registerListener(forNodeMethod: "roundHistory", named: "listeningForRoundHistory", callback: { response in
            
                let characterSet = CharacterSet(charactersIn: ",:")
                let components = response.components(separatedBy: characterSet)
                
                let roundNumber = (components[0] as NSString).intValue
                let dataType = (components[1] == "image") ? DataType.image : DataType.caption
                
                var data: Any = ""
                if dataType == .caption {
                    data = components[2]
                } else if dataType == .image {
                    let string = components[2]
                    if let image = self.base64StringToImage(string) {
                        data = image
                    } else {
                        print("help")
                    }
                }
                
                content.append((Int(roundNumber), dataType, data))
            })
            
            ApplicationState.state.registerListener(forNodeMethod: "GLHF", named: "roundHistoryComplete", callback: { _ in
                
                print(content)
                print(content)
                
            })
            
        })
        
    }
    
    
    //MARK: - Helpers
    
    public enum DataType {
        case caption, image
    }
    
    func base64StringToImage(_ string: String) -> UIImage? {
        var encodedImage = string.replacingOccurrences(of: "~", with: "/")
        
        while encodedImage.lengthOfBytes(using: .utf8) % 4 != 0 {
            encodedImage += "="
        }
        
        guard let data = Data(base64Encoded: encodedImage, options: []) else { return nil }
        return UIImage(data: data)
    }
    
    
    
}
