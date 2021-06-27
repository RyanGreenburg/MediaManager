//
//  CastMemberCollectionViewCell.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/15/21.
//

import UIKit

class CastMemberCollectionViewCell: UICollectionViewCell, CellRegisterable {

    @IBOutlet weak var memberImageView: ServiceRequestingImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        memberImageView.image = nil
        nameLabel.text = nil
        roleLabel.text = nil
    }

    func configure(with castMember: CastMember? = nil, crewMember: CrewMember? = nil) {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor  = UIColor.gray.cgColor
        if let castMember = castMember, let path = castMember.photoPath {
            memberImageView.url = TMDBEndpoint.urlForImagePath(path)
            nameLabel.text = castMember.name
            roleLabel.text = castMember.character
        } else if let crewMember = crewMember, let path = crewMember.photoPath {
            memberImageView.url = TMDBEndpoint.urlForImagePath(path)
            nameLabel.text = crewMember.name
            roleLabel.text = crewMember.job
        }
    }
}
