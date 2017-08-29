//
//  PropertyListCell.swift
//  letusintroduceyou
//
//  Created by Admin on 03/07/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class PropertyListCell: UITableViewCell {

    @IBOutlet weak var bedCount: UILabel!
    @IBOutlet weak var showerCount: UILabel!
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var propertyName: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var address: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
