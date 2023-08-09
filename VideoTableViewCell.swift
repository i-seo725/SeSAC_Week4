//
//  VideoTableViewCell.swift
//  SeSAC_Week4
//
//  Created by 이은서 on 2023/08/09.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        detailLabel.font = .systemFont(ofSize: 13)
        thumbnailImageView.contentMode = .scaleToFill
        detailLabel.numberOfLines = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
