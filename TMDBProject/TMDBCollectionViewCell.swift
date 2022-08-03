//
//  TMDBCollectionViewCell.swift
//  TMDBProject
//
//  Created by 이도헌 on 2022/08/03.
//

import UIKit

class TMDBCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.font = .systemFont(ofSize: 13)
        }
    }
    @IBOutlet weak var genreLabel: UILabel! {
        didSet {
            genreLabel.font = .boldSystemFont(ofSize: 17)
            genreLabel.text = "장르"
        }
    }
    
    @IBOutlet weak var movieImageView: UIImageView! {
        didSet {
//            movieImageView.layer.cornerRadius = 7
            
        }
    }
    @IBOutlet weak var movieTitleLabel: UILabel! {
        didSet {
            movieTitleLabel.font = .systemFont(ofSize: 21, weight: .bold)
        }
    }
    
    @IBOutlet weak var overViewLabel: UILabel! {
        didSet {
            overViewLabel.font = .systemFont(ofSize: 17)
            overViewLabel.textColor = .darkGray
        }
    }
    @IBOutlet weak var detailLabel: UILabel! {
        didSet {
            detailLabel.font = .boldSystemFont(ofSize: 15)
        }
    }
    
    @IBOutlet weak var voteLabel: UILabel! {
        didSet {
            voteLabel.backgroundColor = .white
            voteLabel.font = .systemFont(ofSize: 15)
            voteLabel.layer.cornerRadius = 3
            voteLabel.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shadowView.layer.masksToBounds = true
        shadowView.layer.cornerRadius = 7
        
        // 그림자 색상
        layer.shadowColor = UIColor.black.cgColor
        // 그림자 흐림
        layer.shadowRadius = 7
        // 그림자 불투명도
        layer.shadowOpacity = 0.2
        // 그림자 위치
        layer.shadowOffset = CGSize(width: 3, height: 3)

    }

}
