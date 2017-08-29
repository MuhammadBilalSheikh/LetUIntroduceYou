//
//  SupplierCell.swift
//  letusintroduceyou
//
//  Created by Admin on 07/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SupplierCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
