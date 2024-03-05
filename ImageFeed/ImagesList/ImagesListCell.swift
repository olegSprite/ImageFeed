//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 03.01.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    override func prepareForReuse() {
            super.prepareForReuse()
            cellImageView.kf.cancelDownloadTask()
        }
    
    func setImage(url: String) {
        guard let url = URL(string: url) else { return }
        
        cellImageView.kf.indicatorType = .activity
        self.cellImageView.kf.setImage(with: url, placeholder: UIImage(named: "photo.fill"))
    }
}
