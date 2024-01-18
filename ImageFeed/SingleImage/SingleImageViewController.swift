//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 18.01.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
            didSet {
                guard isViewLoaded else { return }
                imageView.image = image 
            }
        }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
