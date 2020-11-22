//
//  DetailCocktailViewController.swift
//  cocktailMaker
//
//  Created by Claudia Contreras on 3/26/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

class DetailCocktailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var drinkNameLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var IngredientsTextView: UITextView!
    @IBOutlet var instructionsTextView: UITextView!
    
    // For the Loading Screen
    @IBOutlet var loadingView: UIView!
    @IBOutlet var shineView: UIView!
    
    
    // MARK: - Properties
    var cocktailResultController = CocktailResultController()
    var cocktailResult: CocktailResults?
    var buttonPressed: SearchType?
    var cocktailID: IngredientSearch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whichButtonWasPushed()
        view.setGradientBackground2Colors(colorOne: Colors.mainBlue, colorTwo: .black)
        shineView.setGradientBackground3Colors(colorOne: .clear, colorTwo: .white, colorThree: .clear)
        showLoadingScreen()
    }
     
    // MARK: - Functions
    func whichButtonWasPushed() {
        switch buttonPressed {
        case.random:
            view.setGradientBackground2Colors(colorOne: Colors.pinkDark, colorTwo: Colors.pinkLight)
            cocktailResultController.getRandomCocktail { (result) in
                do {
                    let cocktail = try result.get()
                    DispatchQueue.main.async {
                        self.cocktailResult = cocktail.drinks[0]
                        self.hideLoadingScreen()
                        self.updateViews()
                    }
                } catch {
                    print(result)
                }
            }

        case .searchByIngredient:
            guard let cocktailID = cocktailID else { return }
            view.setGradientBackground2Colors(colorOne: Colors.blueDark, colorTwo: Colors.blueLight)
            cocktailResultController.searchCocktailByID(id: cocktailID.drinkID) { (result) in
                do {
                    let cocktail = try result.get()
                    DispatchQueue.main.async {
                        self.cocktailResult = cocktail.drinks[0]
                        self.hideLoadingScreen()
                        self.updateViews()
                    }
                } catch {
                    print(result)
                }
            }
        case .searchByName:
            view.setGradientBackground2Colors(colorOne: Colors.grayDark, colorTwo: Colors.grayLight)
            self.updateViews()
            self.hideLoadingScreen()
        case .locateByLetter:
            view.setGradientBackground2Colors(colorOne: Colors.orangeDark, colorTwo: Colors.orangeLight)
            self.updateViews()
            self.hideLoadingScreen()
        default:
            self.updateViews()
            self.hideLoadingScreen()
        }
    }
    
    func showLoadingScreen() {
        loadingView.bounds.size.width = view.bounds.width - 25
        loadingView.bounds.size.height = view.bounds.height - 40
        loadingView.center = view.center
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView.alpha = 1
        }) { (success) in
            self.animateShineView()
        }
        view.addSubview(loadingView)
    }
    
    func animateShineView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0.2, options: [], animations: {
                self.shineView.transform = CGAffineTransform(translationX: 0, y: -800)
            }) { (success) in
                //self.hideLoadingScreen()
            }
        }
    }
    
    func hideLoadingScreen() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, delay: 0, options: [], animations: {
                self.loadingView.transform = CGAffineTransform(translationX: 0, y: 10)
            }) { (success) in
                UIView.animate(withDuration: 0.3) {
                    self.loadingView.transform = CGAffineTransform(translationX: 0, y: -800)
                }
            }
        }
    }
    
    func updateViews() {
        guard let cocktail = cocktailResult else { return }
        drinkNameLabel.text = cocktail.drinkName
        getImage(with: cocktail)
        getIngredients(with: cocktail)
        instructionsTextView.text = "Instructions:\n\(cocktail.instructions)"
    }
    override func viewWillDisappear(_ animated: Bool) {
        drinkNameLabel.text = ""
        IngredientsTextView.text = ""
        instructionsTextView.text = ""
    }
    
    func getImage(with cocktail: CocktailResults) {
        let imagePath = cocktail.imageString
        cocktailResultController.downloadCocktailImage(path: imagePath ) { (result) in
            guard let imageString = try? result.get() else { return }
            let image = UIImage(data: imageString)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    func getIngredients(with cocktail: CocktailResults) {
        let mirrorCocktail = Mirror(reflecting: cocktail)
        
        var ingredientsArray: [String] = []
        for child in mirrorCocktail.children {
            guard let ingredientKey = child.label else { return }
            let ingredientValue = child.value as? String
            if ingredientKey.contains("ingredient") && ingredientValue != nil {
                ingredientsArray.append(ingredientValue!)
            }
        }
        let ingredient = ingredientsArray.compactMap{ $0 }
        
        var measurementArray: [String] = []
        for child in mirrorCocktail.children {
            guard let measurementKey = child.label else { return }
            let measurementValue = child.value as? String
            if measurementKey.contains("measurement") && measurementValue != nil {
                measurementArray.append(measurementValue!)
            }
        }
        var measurement = measurementArray.compactMap{ $0 }
        IngredientsTextView.text = "Ingredients: \n"
        if ingredient.count != measurement.count  {
            let missing = ingredient.count - measurement.count
            for _ in 0..<missing {
                measurement.append("")
            }
        }
        for i in 0..<ingredient.count {
            IngredientsTextView.text += "- \(ingredient[i]): \(measurement[i])\n"
        }
    }
}
