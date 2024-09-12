//
//  CountryDetailsTableViewCell.swift
//  countriesSampleApp
//
//  Created by Shanmukh D M on 12/09/24.
//

import UIKit

class CountryDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryFlagImg: UIImageView!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var countryDetailsStkView: UIStackView!
    @IBOutlet weak var countryCapitalLbl: UILabel!
    @IBOutlet weak var countryCurrencyLbl: UILabel!
    @IBOutlet weak var countryPopulationLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
//MARK: - Initailization
extension CountryDetailsTableViewCell{
    func configure(with country: Country) {
        self.countryNameLbl.text = country.name
        self.countryCapitalLbl.text = "Capital: \(country.capital)"
        self.countryCurrencyLbl.text = "Currency: \(country.currency)"
        self.countryPopulationLbl.text = "Population: \(country.population ?? 0)"
        
        // Load image from URL
        if let url = URL(string: country.media.flag) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.countryFlagImg.image = image
                    }
                }
            }.resume()
        }
    }
}
