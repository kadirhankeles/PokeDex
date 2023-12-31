//
//  PokemonCVC.swift
//  PokemonAPI
//
//  Created by Macbook Air on 3.11.2023.
//

import UIKit
import Kingfisher


class PokemonCVC: UICollectionViewCell {
    
    static let identifier = "PokemonCVC"
    
    private var grayView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = AppColors.cardBackgroundColor
        return view
    }()
    
    
    private var pokemonImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var pokemonIdLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColors.placeHolderColor
        label.textAlignment = .right
        label.font = AppFonts.cardIdFont
        return label
    }()
    
    private var pokemonLabelName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = AppColors.blackColor
        label.font = AppFonts.cardNameFont
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowRadius = 2
        contentView.layer.cornerRadius = 7
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = AppColors.whiteColor
        contentView.addSubviews([grayView,pokemonImage,pokemonIdLabel,pokemonLabelName])
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with pokemon : PokemonDto) {
        pokemonIdLabel.text = pokemon.idString
        pokemonImage.kf.setImage(with: URL(string: pokemon.imageUrl))
        pokemonLabelName.text = pokemon.name
    }
    
    func setLayouts(){
        NSLayoutConstraint.activate([
            
            grayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            grayView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            grayView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            grayView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.4),
            
            
            pokemonImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pokemonImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonImage.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.8),
            pokemonImage.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.5),
            
            pokemonIdLabel.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 10),
            pokemonIdLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            pokemonIdLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.5),
            

            pokemonLabelName.topAnchor.constraint(equalTo: pokemonImage.bottomAnchor , constant: 5),
            pokemonLabelName.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            pokemonLabelName.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
}
