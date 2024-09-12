//
//  NoDataTableViewCell.swift
//  countriesSampleApp
//
//  Created by Shanmukh D M on 12/09/24.
//


import UIKit

class NoDataTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        textLabel?.text = "No Data Available"
        textLabel?.textAlignment = .center
        textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textLabel?.textColor = .gray
    }
}
