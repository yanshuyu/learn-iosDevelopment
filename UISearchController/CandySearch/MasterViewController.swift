/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class MasterViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  @IBOutlet var searchFooter: SearchFooter!
  @IBOutlet var searchFooterBottomConstraint: NSLayoutConstraint!
  
  private var searchVC: UISearchController!
  var candies: [Candy] = []
  var filteredCandies: [Candy] = [] {
    didSet {
      self.tableView.reloadData()
    }
  }
  var viewingCandies: [Candy] {
    return (navigationItem.searchController?.isActive ?? false) ? self.filteredCandies : self.candies
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.candies = Candy.candies()
    let searchVC = UISearchController(searchResultsController: nil)
    searchVC.searchResultsUpdater = self
    searchVC.searchBar.placeholder = "search candies"
    searchVC.obscuresBackgroundDuringPresentation = false
    // search bar scope
    searchVC.searchBar.scopeButtonTitles = Candy.Category.allCases.map {$0.rawValue }
    searchVC.searchBar.delegate = self
    self.searchVC = searchVC
    
    // intergrade search view controller with searchable interface
    self.navigationItem.searchController = searchVC
  
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard
      segue.identifier == "ShowDetailSegue",
      let indexPath = tableView.indexPathForSelectedRow,
      let detailViewController = segue.destination as? DetailViewController
      else {
        return
    }
    
    let candy = self.viewingCandies[indexPath.row]
    detailViewController.candy = candy
  }
}

extension MasterViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return self.viewingCandies.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                             for: indexPath)
    let candy = viewingCandies[indexPath.row]
    cell.textLabel?.text = candy.name
    cell.detailTextLabel?.text = candy.category.rawValue
    return cell
  }
}

//
// MARK: - UISearchResultsUpdating delegate
//
extension MasterViewController: UISearchResultsUpdating {
  private func filterCandies(keyWord: String?, category: Candy.Category?) -> [Candy] {
    let keyWord = keyWord ?? ""
    let category = category ?? Candy.Category.all
    return self.candies.filter { (candy) -> Bool in
      let isMatchName = keyWord.isEmpty || candy.name.lowercased().contains(keyWord.lowercased())
      let isMatchCategory = category == .all || candy.category == category
      return isMatchName && isMatchCategory
    }
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    let searchText = self.searchVC.searchBar.text
    let selectedScopedTile = self.searchVC.searchBar.scopeButtonTitles == nil ? "" : self.searchVC.searchBar.scopeButtonTitles![self.searchVC.searchBar.selectedScopeButtonIndex]
    let selectedCategory = Candy.Category(rawValue: selectedScopedTile)
    self.filteredCandies = filterCandies(keyWord: searchText, category: selectedCategory)
  }
}


//
// MARK: - UISearchBar delegate
//
extension MasterViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    let searchText = self.searchVC.searchBar.text
    let selectedScopedTile = self.searchVC.searchBar.scopeButtonTitles == nil ? "" : self.searchVC.searchBar.scopeButtonTitles![self.searchVC.searchBar.selectedScopeButtonIndex]
    let selectedCategory = Candy.Category(rawValue: selectedScopedTile)
    self.filteredCandies = filterCandies(keyWord: searchText, category: selectedCategory)
  }
}
