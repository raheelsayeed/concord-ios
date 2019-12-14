//
//  LabCell.swift
//  Concord
//
//  Created by Raheel Sayeed on 12/13/19.
//  Copyright © 2019 Medical Gear. All rights reserved.
//

import UIKit
import SMARTMarkers

class LabCell: UITableViewCell {

    @IBOutlet weak var graphView: LineGraphView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
