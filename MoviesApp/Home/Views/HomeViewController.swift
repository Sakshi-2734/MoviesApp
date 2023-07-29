import UIKit

class HomeViewController: UIViewController {
    
    //ViewModel Instance
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel(withApiLayer: MovieApiManager())
    }()
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        
        viewModel.delegate = self
        viewModel.triggerMovieCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setUpTableView() {
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "HomeTableViewCell")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell",
                                                       for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        //Set Genre details for the Cell
        cell.cellDelegate = self
        DispatchQueue.main.async { [weak self] in
            if let genreData = self?.viewModel.getMovieObject(indexPath.row) {
                cell.movieGenreLabel.text = genreData.genre
                cell.setMovieDetails(genreData.movies, indexPath.row)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    /**
     Reload TableView once Api call fetches Movie details
     */
    func refreshData() {
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadData()
        }
    }
    
    /**
     Handle Error prompt
     */
    func handleErrorPrompt(_ message: String) {
         DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                print("Default tapped")
            }
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: HomeTableViewProtocol {
    /**
     Map MovieDetails for selected Genre - Movie item
     */
    func mapSelectedMovieDetail(_ genre: Int, _ movieIndex: Int) {
        if let movieDetails = viewModel.getMovieDetails(genre, movieIndex) {
//            let viewController = DetailsViewController(nibName: "DetailsViewController", bundle: Bundle.main)
//            viewController.movieDetails = movieDetails
//            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
