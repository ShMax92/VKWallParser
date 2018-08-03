//
//  TableViewCell.swift
//  VKWallParser
//
//  Created by Maxim Shirko on 29.07.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell{

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var imageArray = [String] ()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
