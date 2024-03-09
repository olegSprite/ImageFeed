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
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var cellImageView: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
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
        likeButton.setImage(UIImage(named: curentLike ? "Active" : "No Active"), for: .normal)
    }
    
    func configure(dateText: String, isLiked: Bool) {
        self.dateLabel.text = dateText
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        self.likeButton.setImage(likeImage, for: .normal)
    }
    
    @IBAction private func likeButtonTap(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}
