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
//    var castData: [Cast] = []
    var pageNumber = 1
    let totalPage = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TMDBCollectionView.dataSource = self
        TMDBCollectionView.delegate = self
        TMDBCollectionView.prefetchDataSource = self
        
        let nib = UINib(nibName: TMDBCollectionViewCell.id, bundle: nil)
        TMDBCollectionView.register(nib, forCellWithReuseIdentifier: TMDBCollectionViewCell.id)
        collectionViewLayout()
        
        requestTMDB(page: pageNumber)
        
        
        
    }
    
    @objc func search() {
        
    }
    
    func requestTMDB(page: Int) {
        
        let url = "\(EndPoint.TmdbURL)api_key=\(APIKey.TMDB)&page=\(page)"

        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                for movie in json["results"].arrayValue {
                    
                    let title = movie["title"].stringValue
                    let release = movie["release_date"].stringValue
                    let overview = movie["overview"].stringValue
                    let image = EndPoint.tmdImage + movie["backdrop_path"].stringValue
                    let vote = movie["vote_average"].doubleValue
                    let poster = EndPoint.tmdImage + movie["poster_path"].stringValue
                    let castId = movie["id"].intValue
                    
//                    self.fetchMovieId(id: castId)
                    
                    let data = TMDB(title: title, release: release, overview: overview, image: image, vote: vote, poster: poster, movieid: castId)
                    self.movieData.append(data)
                    
                }
//                print(self.movieData[0].title)
                print(self.movieData[0].movieid)
                self.TMDBCollectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    func fetchMovieId(id: Int) {
//        let url = "\(EndPoint.getCastCrew)/\(id)/credits?api_key=\(APIKey.TMDB)"
//        AF.request(url, method: .get).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
////                print("JSON: \(json)")
//
//                for cast in json["cast"].arrayValue {
//                    let name = cast["name"].stringValue
//                    let profile = EndPoint.tmdImage + cast["profile_path"].stringValue
//
//                    let castData = Cast(name: name, profile: profile)
//                    self.castData.append(castData)
//                }
////                print(self.castData)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
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

extension TMDBViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("==== prefetchIndexPath: \(indexPaths) ====")

        for indexPath in indexPaths {
            if movieData.count-1 == indexPath.item && movieData.count < totalPage {
             pageNumber += 1

                requestTMDB(page: pageNumber)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("==== cancelPrefetchingForItemsAt: \(indexPaths) ====")
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
        
        
//        print("\(movieData[indexPath.row].movieid)")
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: StoryboardName.main, bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: DetailViewController.id) as? DetailViewController else { return }
        
        vc.movieName = movieData[indexPath.row].title
        vc.movieBackgroundImage = movieData[indexPath.row].image
        vc.posterImage = movieData[indexPath.row].poster
//        vc.castInfo = castData[indexPath.row]
        vc.movieid = movieData[indexPath.row].movieid
        print(vc.movieid)
        
        navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
