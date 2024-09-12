//
//  ViewController.swift
//  countriesSampleApp
//
//  Created by Shanmukh D M on 12/09/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var userInfoBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Parameters
    
    private let homeViewModel = HomeViewModel()
    private let searchBar = UISearchBar()
    private let filterButton = UIButton(type: .system)
    
    //MARK: - IBActions
    @IBAction func userInfoBtnAction(_ sender: Any) {
        // add the function here
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.setupBindings()
        self.setupTableViewHeader()
        homeViewModel.fetchCountries()
    }
}

//MARK: - Initialization
extension HomeViewController{
    func setupUI(){
        self.dateTimeLbl.text = self.homeViewModel.formattedCurrentDateTime()
    }
    private func setupBindings() {
        self.homeViewModel.didUpdateCountries = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        self.homeViewModel.didFailWithError = { error in
            print("Failed to fetch countries:", error)
        }
    }
}

//MARK: - Button Actions
extension HomeViewController{
    @objc private func didTapFilter() {
        let alert = UIAlertController(title: "Filter by Population", message: "Select population range", preferredStyle: .actionSheet)
        
        let lessThan1Million = UIAlertAction(title: "< 1 Million", style: .default) { [weak self] _ in
            self?.homeViewModel.filterCountries(byPopulationRange: 1_000_000)
        }
        
        let lessThan5Million = UIAlertAction(title: "< 5 Million", style: .default) { [weak self] _ in
            self?.homeViewModel.filterCountries(byPopulationRange: 5_000_000)
        }
        
        let lessThan10Million = UIAlertAction(title: "< 10 Million", style: .default) { [weak self] _ in
            self?.homeViewModel.filterCountries(byPopulationRange: 10_000_000)
        }
        
        let resetFilter = UIAlertAction(title: "Reset Filter", style: .destructive) { [weak self] _ in
            self?.homeViewModel.filterCountries(byPopulationRange: Int.max) // Reset filter to show all countries
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(lessThan1Million)
        alert.addAction(lessThan5Million)
        alert.addAction(lessThan10Million)
        alert.addAction(resetFilter)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

//MARK: - TableView
extension HomeViewController{
    private func setupTableViewHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        
        // Search Bar setup
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search countries by name"
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(searchBar)
        
        // Filter Button setup
        self.filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        self.filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
        self.filterButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(filterButton)
        
        // Layout Constraints for Search Bar and Filter Button
        NSLayoutConstraint.activate([
            // Search Bar constraints
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -10),
            searchBar.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            
            // Filter Button constraints
            filterButton.topAnchor.constraint(equalTo: searchBar.topAnchor),
            filterButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 10),
            filterButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            
            filterButton.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
        
        tableView.tableHeaderView = headerView
        tableView.register(NoDataTableViewCell.self, forCellReuseIdentifier: "NoDataTableViewCell")
        tableView.dataSource = self
    }
}

//MARK: - SearchBarDelegate
extension HomeViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.homeViewModel.searchCountry(by: searchText)
    }
}

//MARK: - TableViewDelegate
extension HomeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeViewModel.filteredCountries.isEmpty ? 1 : self.homeViewModel.filteredCountries.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.homeViewModel.filteredCountries.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as? NoDataTableViewCell else {return UITableViewCell()}
            return cell
        }else{
            let country = self.homeViewModel.filteredCountries[indexPath.row]
            guard let countryDetailsTVC = tableView.dequeueReusableCell(withIdentifier: "CountryDetailsTableViewCell", for: indexPath) as? CountryDetailsTableViewCell else {return UITableViewCell()}
            countryDetailsTVC.configure(with: country)
            
            return countryDetailsTVC
        }
    }
}

//MARK: - TableViewDelegate
extension HomeViewController:UITableViewDelegate{
    
    
}
