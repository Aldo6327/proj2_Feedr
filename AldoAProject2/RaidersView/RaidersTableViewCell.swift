//
//  RaidersTableViewCell.swift
//  AldoAProject2
//
//  Created by Aldo Ayala on 10/17/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//

import UIKit

class RaidersTableViewCell: UITableViewCell {
    @IBOutlet weak var raidersLabel: UILabel!
    @IBOutlet weak var raidersImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
