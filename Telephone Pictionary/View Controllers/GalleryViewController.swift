//
//  GalleryViewController.swift
//  Telephone Pictionary
//
//  Created by Cal Stephens on 2/26/17.
//  Copyright © 2017 Cal Stephens. All rights reserved.
//

import UIKit

public enum DataType {
    case caption, image
}

typealias GalleryItem = (roundNumber: Int, username: String, type: DataType, data: Any)

class GalleryViewController : UIPageViewController, UIPageViewControllerDataSource {
    
    
    //MARK: - Present
    
    static func present(in navigationController: UINavigationController?, withGalleryContent content: [GalleryItem]) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gallery") as! GalleryViewController
        
        controller.content = content
        controller.content.sort { $0.roundNumber < $1.roundNumber }
        
        controller.dataSource = controller
        navigationController?.pushViewController(controller, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    //MARK: - Setup
    
    var content = [GalleryItem]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.setViewControllers([self.createViewController(for: 0)!], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.index(of: viewController) else { return nil }
        return createViewController(for: index + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.index(of: viewController) else { return nil }
        return createViewController(for: index - 1)
    }
    
    func index(of viewController: UIViewController) -> Int? {
        guard let galleryItem = (viewController as? GalleryItemViewController)?.item else { return nil }
        return galleryItem.roundNumber
    }
    
    
    //MARK: - Content Controllers
    
    func createViewController(for index: Int) -> UIViewController? {
        if index < 0 || index >= content.count { return nil }
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "galleryItem") as! GalleryItemViewController
        controller.item = self.content[index]
        return controller
    }
    
    
    //MARK: - User Interaction
    
    @IBAction func donePressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}

class GalleryItemViewController : UIViewController {
    
    var item: GalleryItem!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        authorLabel.text = "by \(item.username)"
        
        if let content = item.data as? String {
            textLabel.text = content
            imageView.isHidden = true
        } else if let image = item.data as? UIImage {
            textLabel.isHidden = true
            imageView.image = image
        } else {
            textLabel.text = "something went wrong"
            imageView.isHidden = true
        }
    }
    
}
