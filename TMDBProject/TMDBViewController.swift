//
//  TMDBViewController.swift
//  TMDBProject
//
//  Created by 이도헌 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class TMDBViewController: UIViewController {
    
    @IBOutlet weak var TMDBCollectionView: UICollectionView!
    
    var movieData: [TMDB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TMDBCollectionView.dataSource = self
        TMDBCollectionView.delegate = self
        
        let nib = UINib(nibName: TMDBCollectionViewCell.id, bundle: nil)
        TMDBCollectionView.register(nib, forCellWithReuseIdentifier: TMDBCollectionViewCell.id)
        collectionViewLayout()
        
        requestTMDB()
        
    }
    
    @objc func search() {
        
    }
    
    func requestTMDB() {
        let url = "\(EndPoint.TmdbURL)api_key=\(APIKey.TMDB)"
        let imageUrl = "https://image.tmdb.org/t/p/w500"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for movie in json["results"].arrayValue {
                    
                    let title = movie["title"].stringValue
                    let release = movie["release_date"].stringValue
                    let overview = movie["overview"].stringValue
                    let image = imageUrl + movie["backdrop_path"].stringValue
                    let vote = movie["vote_average"].doubleValue
                    
                    let data = TMDB(title: title, release: release, overview: overview, image: image, vote: vote)
                    
                    self.movieData.append(data)
                    
                }
                
                self.TMDBCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func collectionViewLayout() {
        
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 10
        let itemCount: CGFloat = 1
        
        let width = (UIScreen.main.bounds.width - space * (itemCount + 1)) / itemCount
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        
        TMDBCollectionView.collectionViewLayout = layout
    }
}



extension TMDBViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = TMDBCollectionView.dequeueReusableCell(withReuseIdentifier: TMDBCollectionViewCell.id, for: indexPath) as? TMDBCollectionViewCell else { return UICollectionViewCell() }
        
        let url = URL(string: movieData[indexPath.row].image)
        cell.movieImageView.kf.setImage(with: url)
        cell.movieImageView.contentMode = .scaleAspectFill
        cell.movieTitleLabel.text = movieData[indexPath.row].title
        cell.overViewLabel.text = movieData[indexPath.row].overview
        cell.voteLabel.text = " " + String(Int(movieData[indexPath.row].vote)) + " "
        
        let date = DateFormatter()
        date.dateFormat = "yyyy.mm.dd"
        if let changedDate = date.date(from: movieData[indexPath.row].release) {
            cell.dateLabel.text = date.string(from: changedDate)
        } else {
            print("날짜 표기 오류 발생")
        }
        
        
    
        
        return cell
    }
}
