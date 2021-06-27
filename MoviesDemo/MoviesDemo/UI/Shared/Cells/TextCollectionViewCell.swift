//
//  TextCollectionViewCell.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/15/21.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell, CellRegisterable {

    @IBOutlet weak var textLabel: UILabel!
    
    func configure(with text: String) {
        textLabel.text = text
    }
}
