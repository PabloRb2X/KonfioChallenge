//
//  DogViewCell.swift
//  KDogsApp
//
//  Created by Pablo Ramirez on 19/06/25.
//

import UIKit

final class DogViewCell: UICollectionViewCell {
    
    @IBOutlet weak var infoContainerView: UIView! {
        didSet {
            infoContainerView.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var dogNameLabel: UILabel! {
        didSet {
            dogNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            dogNameLabel.textColor = .customBlack
        }
    }
    
    @IBOutlet weak var dogDescriptionLabel: UILabel! {
        didSet {
            dogDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
            dogDescriptionLabel.numberOfLines = 0
            dogDescriptionLabel.textColor = .customGray
        }
    }
    
    @IBOutlet weak var dogAgeLabel: UILabel! {
        didSet {
            dogAgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            dogAgeLabel.textColor = .customBlack
        }
    }
    
    @IBOutlet weak var dogImageView: UIImageView! {
        didSet {
            dogImageView.contentMode = .scaleAspectFill
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dogImageView.image = nil
        dogNameLabel.text = ""
        dogDescriptionLabel.text = ""
        dogAgeLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoContainerView.layer.cornerRadius = 8
        dogImageView.layer.cornerRadius = 8
    }
    
    func setupComponents(dogModel: DogModel) {
        dogNameLabel.text = dogModel.dogName
        dogDescriptionLabel.text = dogModel.description
        dogAgeLabel.text = "Almost \(dogModel.age) years"
        dogImageView.imageFromServerURL(dogModel.image, placeHolder: UIImage(named: "no_image"))
    }
}
