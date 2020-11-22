//
//  CocktailTableViewController.swift
//  cocktailMaker
//
//  Created by Claudia Contreras on 3/29/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import UIKit

class CocktailTableViewController: UITableViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var searchBar: UISearchBar!
    
    
    //MARK: - Properties
    var buttonPressed: SearchType?
    var cocktailResultController = CocktailResultController()
    var cocktails: [CocktailResults] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var drinks: [IngredientSearch] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var cocktail: CocktailResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cocktails.count <= 0 {
            return drinks.count
        } else {
            return cocktails.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
        if cocktails.count <= 0 {
            let drink = drinks[indexPath.row]
            cell.textLabel?.text = drink.drinkName
            cell.backgroundColor = Colors.blueDark
        } else {
            let drink = cocktails[indexPath.row]
            cell.textLabel?.text = drink.drinkName
            switch buttonPressed {
            case .searchByName:
                cell.backgroundColor = Colors.grayDark
            default:
                cell.backgroundColor = Colors.orangeDark
            }
            
            
        }
        return cell
    }
    
    // MARK:  - Functions
    func whichButtonWasPushed(searchTerm: String) {
        switch buttonPressed {
        case .searchByName:
            cocktailResultController.searchCocktailByName(searchTerm: searchTerm) { (result) in
                do {
                    let drinks = try result.get()
                    DispatchQueue.main.async {
                        self.cocktails = drinks.drinks
                    }
                } catch {
                    print(result)
                }
            }
        case .locateByLetter:
            cocktailResultController.searchCocktailByLetter(searchTerm: searchTerm) { (result) in
                do {
                    let drinks = try result.get()
                    DispatchQueue.main.async {
                        self.cocktails = drinks.drinks
                    }
                } catch {
                    print(result)
                }
            }
        case .searchByIngredient:
            cocktailResultController.searchCocktailByIngredient(searchTerm: searchTerm) { (result) in
                do {
                    let drinks = try result.get()
                    DispatchQueue.main.async {
                        self.drinks = drinks.drinks
                    }
                } catch {
                    print(result)
                }
            }
        default:
            return
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailFromTableSegue",
            let DetailVC = segue.destination as? DetailCocktailViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            if cocktails.count <= 0 {
                let cocktail = drinks[selectedIndexPath.row]
                DetailVC.cocktailID = cocktail
                DetailVC.buttonPressed = buttonPressed
            } else {
                DetailVC.buttonPressed = buttonPressed
                DetailVC.cocktailResult = cocktails[selectedIndexPath.row]
            }
        }
    }
}



// MARK: - Extension

extension CocktailTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        
        self.whichButtonWasPushed(searchTerm: searchTerm)
        
    }
}
