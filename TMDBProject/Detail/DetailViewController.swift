
import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON
import Accelerate

enum SectionName: String, CaseIterable{
    case overView = "OverView"
    case cast = "Cast"
    case crew = "Crew"
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var DetailHeaderUIview: UIView!
    @IBOutlet weak var DetailTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    // 값을 받을 변수
    var movieBackgroundImage: String?
    var posterImage: String?
    var movieName: String?
    var movieid: Int?
    var castInfo: [Cast] = []
    var crewInfo: [Crew] = []
    var overview: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DetailTableView.delegate = self
        DetailTableView.dataSource = self
        
        let castNib = UINib(nibName: DetailTableViewCell.id, bundle: nil)
        DetailTableView.register(castNib, forCellReuseIdentifier: DetailTableViewCell.id)
        
        let overViewNib = UINib(nibName: OverViewTableViewCell.id, bundle: nil)
        DetailTableView.register(overViewNib, forCellReuseIdentifier: OverViewTableViewCell.id)
        
        DetailTableView.rowHeight = 80
        
        title = movieName
        navigationController?.navigationBar.tintColor = .black
        
        // 값 전달
        movieNameLabel.text = movieName
        
        imageUrl(data: movieBackgroundImage!, imageView: backgroundImageView)
        imageUrl(data: posterImage!, imageView: posterImageView)
        
        backgroundImageView.contentMode = .scaleToFill
        posterImageView.contentMode = .scaleToFill
        
        design()
        guard let movieid = movieid else {
            print("오류")
            return
        }
        fetchMovieId(id: movieid)
    }
    
    func fetchMovieId(id: Int) {
        let url = "\(EndPoint.getCastCrew)/\(id)/credits?api_key=\(APIKey.TMDB)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for cast in json["cast"].arrayValue {
                    let name = cast["name"].stringValue
                    let profile = EndPoint.tmdImage + cast["profile_path"].stringValue
                    let character = cast["character"].stringValue
                    
                    let data = Cast(name: name, profile: profile, character: character)
                    self.castInfo.append(data)
                }
                
                for crew in json["crew"].arrayValue {
                    let name = crew["name"].stringValue
                    let profile = EndPoint.tmdImage + crew["profile_path"].stringValue
                    let job = crew["job"].stringValue
                    
                    let data = Crew(name: name, profile: profile, job: job)
                    self.crewInfo.append(data)
                    
                }
                self.DetailTableView.reloadData()
                
                print(self.castInfo[0])
                print(self.crewInfo[0])
                print(self.castInfo.count)
                print(self.crewInfo.count)
                
//                print(self.castInfo)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func imageUrl(data: String, imageView: UIImageView!) {
        
        let url = URL(string: data)
        imageView.kf.setImage(with: url)
        
    }
    
    func design() {
        
        movieNameLabel.textColor = .white
        movieNameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        movieNameLabel.numberOfLines = 2
        
        posterImageView.layer.borderWidth = 1
        posterImageView.layer.borderColor = UIColor.systemGray.cgColor
        posterImageView.layer.cornerRadius = 10
        
        blurView.backgroundColor = .black.withAlphaComponent(0.4)
        
        
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionName.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return castInfo.count
        case 2:
            return crewInfo.count
        default :
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = DetailTableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.id, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
    
        if indexPath.section == 0 {
            guard let cell = DetailTableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.id, for: indexPath) as? OverViewTableViewCell else { return UITableViewCell() }

            cell.overViewLabel.text = overview
            
            return cell
            
        } else if indexPath.section == 1 {

            let url = URL(string: castInfo[indexPath.row].profile)
            cell.castImageView.kf.setImage(with: url)
            cell.nameLabel.text = castInfo[indexPath.row].name
            cell.characterLabel.text = castInfo[indexPath.row].character
            
            return cell
            
        } else if indexPath.section == 2 {
            
            let url = URL(string: crewInfo[indexPath.row].profile)
            cell.castImageView.kf.setImage(with: url)
            cell.nameLabel.text = crewInfo[indexPath.row].name
            cell.characterLabel.text = crewInfo[indexPath.row].job
            
            
            return cell
            
        } else {
            
        return UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return SectionName.overView.rawValue
        case 1:
            return SectionName.cast.rawValue
        case 2:
            return SectionName.crew.rawValue
        default:
            return "오류 발생"
        }
    }
}
