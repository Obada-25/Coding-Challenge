//
//  RepoCell.swift
//  Coding Challenge
//
//  Created by obada darkznly on 01.04.22.
//

import UIKit

class RepoCell: UITableViewCell {
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    
    // MARK: Cell's life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        costumizeCell()
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        descriptionLabel.text = ""
        dateLabel.text = ""
        starsCountLabel.text = ""
    }
    
    // MARK: Cell's setup
    
    func costumizeCell() {
        nameLabel.textColor = .systemBlue
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        
        descriptionLabel.textColor = .label
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        
        dateLabel.textColor = .secondaryLabel
        dateLabel.font = .systemFont(ofSize: 12)
        
        starsCountLabel.textColor = .secondaryLabel
        starsCountLabel.font = .systemFont(ofSize: 12)
    }
    
    func populate(_ repo: Repo) {
        nameLabel.text = repo.name
        descriptionLabel.text = repo.description
        starsCountLabel.text = String(repo.stargazersCount)
        
        if let dateString = DateManager.shared.getDate(from: repo.createdAt) {
            dateLabel.text = dateString
        }
    }
}
