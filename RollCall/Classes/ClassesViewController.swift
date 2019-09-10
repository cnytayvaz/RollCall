//
//  ClassesViewController.swift
//  RollCall
//
//  Created by Cüneyt AYVAZ on 6.09.2019.
//  Copyright © 2019 Cüneyt AYVAZ. All rights reserved.
//

import UIKit

class ClassesViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var classes: [String] = []
    var filteredClasses: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let rowItemCount = 3
    let itemSpacing = 8
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classes.append("12 Fen - A")
        classes.append("12 Fen - B")
        classes.append("12 Fen - C")
        classes.append("12 Fen - D")
        classes.append("12 Fen - E")
        classes.append("12 TM - A")
        
        classes.append("11 Fen - A")
        classes.append("11 Fen - B")
        classes.append("11 Fen - C")
        classes.append("11 Fen - D")
        classes.append("11 Fen - E")
        classes.append("11 TM - A")
        
        classes.append("10 Fen - A")
        classes.append("10 Fen - B")
        classes.append("10 Fen - C")
        classes.append("10 Fen - D")
        classes.append("10 Fen - E")
        classes.append("10 TM - A")
        
        classes.append("9 - A")
        classes.append("9 - B")
        classes.append("9 - C")
        classes.append("9 - D")
        classes.append("9 - E")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Class"
        navigationItem.searchController = searchController
        
        collectionView.register(ClassCollectionViewCell.nib, forCellWithReuseIdentifier: ClassCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func isBackButtonHidden() -> Bool {
        return true
    }
    
    override func isInteractivePopGestureRecognizerEnabled() -> Bool {
        return false
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredClasses = classes.filter({( item: String) -> Bool in
            return item.lowercased().contains(searchText.lowercased())
        })
    }
}

extension ClassesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = ClassDetailViewController()
        pushViewController(viewController: viewController)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredClasses.count
        }
        else {
            return classes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassCollectionViewCell.identifier, for: indexPath) as! ClassCollectionViewCell
        
        if isFiltering() {
            cell.configure(with: filteredClasses[(indexPath.section * rowItemCount) + indexPath.row])
        }
        else {
            cell.configure(with: classes[(indexPath.section * rowItemCount) + indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.size.width - CGFloat(integerLiteral: ((rowItemCount - 1) * itemSpacing))) / CGFloat(integerLiteral: rowItemCount)),
                      height: ((collectionView.frame.size.width - CGFloat(integerLiteral: ((rowItemCount - 1) * itemSpacing))) / CGFloat(integerLiteral: rowItemCount)))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(integerLiteral: itemSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(integerLiteral: itemSpacing)
    }
    
}

extension ClassesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
}
