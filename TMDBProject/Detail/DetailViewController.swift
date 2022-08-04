
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var DetailHeaderUIview: UIView!
    @IBOutlet weak var DetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DetailTableView.delegate = self
        DetailTableView.dataSource = self
        
        let nib = UINib(nibName: DetailTableViewCell.id, bundle: nil)
        DetailTableView.register(nib, forCellReuseIdentifier: DetailTableViewCell.id)
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
