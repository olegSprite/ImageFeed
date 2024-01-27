//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 03.01.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
}
