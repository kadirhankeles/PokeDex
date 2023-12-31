//
//  HomeVCExtension.swift
//  PokemonAPI
//
//  Created by Macbook Air on 3.11.2023.
//

import UIKit

extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCVC.identifier, for: indexPath) as! PokemonCVC
        
        cell.configure(with: pokemons[indexPath.row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        closeSearchResignFirstResponder()

        
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.bounds.height
        let scrollOffset = scrollView.contentOffset.y
        
        let scrollPercentage = (scrollOffset + visibleHeight) / contentHeight
        
        if scrollPercentage >= AppConstants.infinityScrollPercentage {
            
            let now = Date()
            if let lastRequestTime = lastRequestTime, now.timeIntervalSince(lastRequestTime) < AppConstants.infinityScrollLateLimitSecond {
                return
            }
            
            viewModel.getNewPokemons()
            
            self.lastRequestTime = now
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pokemonId = pokemons[indexPath.row].id
        let service : PokemonService = PokemonManager()
        let destinationViewModel = DetailViewModel(pokemonService: service)
        let destinationVC = DetailViewController(viewModel: destinationViewModel)
        destinationVC.pokemonId = pokemonId
        destinationVC.pokemons = pokemons
        
        closeSearchResignFirstResponder()
        
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
}

extension HomeViewController {
    
    func initialConfig(){
        
        let logoImage = AppIcons.appLogoSmall
        let barLogo = UIBarButtonItem(image: logoImage, style: .plain, target: self, action: nil)
        let appTitle = UIBarButtonItem(title: AppTexts.appName, style: .plain, target: self, action: nil)
        
        appTitle.setTitleTextAttributes([.foregroundColor : AppColors.whiteColor!, .font : AppFonts.titleBoldFont ?? UIFont.systemFont(ofSize: 30, weight: .bold)], for: .normal)
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItems = [barLogo,appTitle]
        whiteView.addSubview(pokemonsCollectionView)
        view.addSubviews([searchPokemonBar,whiteView,sortButton,sortView])
        
        pokemonsCollectionView.delegate = self
        pokemonsCollectionView.dataSource = self
        pokemonsCollectionView.register(PokemonCVC.self, forCellWithReuseIdentifier: PokemonCVC.identifier)
        
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            searchPokemonBar.topAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!,constant: 5),
            searchPokemonBar.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
            searchPokemonBar.widthAnchor.constraint(equalToConstant: view.frame.width * 0.85),
            
            whiteView.topAnchor.constraint(equalTo: searchPokemonBar.bottomAnchor, constant: 15),
            whiteView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
            whiteView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10),
            whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -10),
            
            pokemonsCollectionView.topAnchor.constraint(equalTo: whiteView.topAnchor,constant: 25),
            pokemonsCollectionView.leftAnchor.constraint(equalTo: whiteView.leftAnchor,constant: 15),
            pokemonsCollectionView.rightAnchor.constraint(equalTo: whiteView.rightAnchor,constant: -15),
            pokemonsCollectionView.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor,constant: -10),
            
            
            sortButton.topAnchor.constraint(equalTo: searchPokemonBar.searchTextField.topAnchor),
            sortButton.leftAnchor.constraint(equalTo: searchPokemonBar.rightAnchor,constant: 5),
            sortButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10),
            sortButton.heightAnchor.constraint(equalToConstant: 40),
            sortButton.widthAnchor.constraint(equalToConstant: 40),
            
            sortView.topAnchor.constraint(equalTo: sortButton.bottomAnchor , constant: 10),
            sortView.rightAnchor.constraint(equalTo: sortButton.rightAnchor , constant: -10),
            sortView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.18),
            sortView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.35)
        ])
        
    }
    
    
    @objc
    func sortButtonPressed(){
        
        closeSearchResignFirstResponder()
        
        let sortViewState = self.sortView.isHidden
        
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self else {  return  }
            self.sortView.isHidden = !sortViewState
        }
        
    }
    
}

extension HomeViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                
        if let searchedText = searchBar.text {
            let searchedLowerText = searchedText.lowercased()
            viewModel.searchPokemon(text: searchedLowerText)
        }
        
        sortView.nameSortRadioButton.isUserInteractionEnabled = true
        sortView.numberSortedRadioButton.isUserInteractionEnabled = true
        
    }
    func closeSearchResignFirstResponder() {
        searchPokemonBar.resignFirstResponder()
    }
}


extension HomeViewController : SortViewProtocol {
    
    func sortTypeChanged(newType: SortTypes) {
        switch newType {
        case .name:
            viewModel.changeSortMethodName()
            sortButton.setImage(AppIcons.nameSortIcon, for: .normal)
        case .number:
            viewModel.changeSortMethodId()
            sortButton.setImage(AppIcons.numberSortIcon, for: .normal)
        }
        self.sortView.isHidden = true
    }
}


