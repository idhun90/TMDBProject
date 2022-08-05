//
//  DetailTableViewCell.swift
//  TMDBProject
//
//  Created by 이도헌 on 2022/08/04.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        castImageView.contentMode = .scaleAspectFill
        castImageView.layer.cornerRadius = 5
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        characterLabel.font = .systemFont(ofSize: 13)
    }
    
}
