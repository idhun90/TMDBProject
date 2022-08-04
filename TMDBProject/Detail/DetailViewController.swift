
import UIKit
import Kingfisher

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DetailTableView.delegate = self
        DetailTableView.dataSource = self
        
        let nib = UINib(nibName: DetailTableViewCell.id, bundle: nil)
        DetailTableView.register(nib, forCellReuseIdentifier: DetailTableViewCell.id)
        
        movieNameLabel.text = movieName
        
        imageUrl(data: movieBackgroundImage!, imageView: backgroundImageView)
        imageUrl(data: posterImage!, imageView: posterImageView)
        
        backgroundImageView.contentMode = .scaleAspectFill
        posterImageView.contentMode = .scaleAspectFill
        
        design()
    }
    
    func imageUrl(data: String, imageView: UIImageView!) {
        
        let url = URL(string: data)
        imageView.kf.setImage(with: url)
        
    }
    
    func design() {
        
        movieNameLabel.textColor = .white
        movieNameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        posterImageView.layer.borderWidth = 2
        posterImageView.layer.borderColor = UIColor.systemGray6.cgColor
        
        blurView.backgroundColor = .black.withAlphaComponent(0.4)
        
        
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = DetailTableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.id, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        
        
        return cell
    }
}
