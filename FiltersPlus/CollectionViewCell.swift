//
//  CollectionViewCell.swift
//  FiltersPlus
//
//  Created by MacMini on 8.11.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterNamelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filterImageView.layer.cornerRadius = 16
        filterImageView.clipsToBounds = true
        // Initialization code
    }

}
