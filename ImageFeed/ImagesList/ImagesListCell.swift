//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Олег Спиридонов on 03.01.2024.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    weak var delegate: ImagesListCellDelegate?
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
    }
    
    func setImage(url: String) {
        guard let url = URL(string: url) else { return }
        cellImageView.kf.indicatorType = .activity
        self.cellImageView.kf.setImage(with: url, placeholder: UIImage(named: "Stub"))
    }
    
    func setIsLiked(_ curentLike: Bool) {
        if curentLike {
            likeButton.setImage(UIImage(named: "Active"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "No Active"), for: .normal)
        }
    }
    
    @IBAction func likeButtonTap(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}
