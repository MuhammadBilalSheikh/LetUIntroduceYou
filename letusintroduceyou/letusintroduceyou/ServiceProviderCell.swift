//
//  ServiceProviderCell.swift
//  letusintroduceyou
//
//  Created by Admin on 07/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ServiceProviderCell: UITableViewCell {

    @IBOutlet weak var suburbLabel: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var serviceProviderName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
