//
//  CoinListViewController.swift
//  plutus
//
//  Created by Eddie Long on 22/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import UIKit
import MBProgressHUD
import SWLogger

protocol CoinListViewDelegate {
    func onCoinsSelected(coins : [Coin])
}

class CoinListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let CoinListCellIdentifier = "coin_list_item"
    public var presenter : PresenterProtocol? = nil
    
    var progressView = MBProgressHUD()
    public var delegate : CoinListViewDelegate? = nil
    
    var coinList = [Coin]()
    var filteredCoins = [Coin]()
    var selectedCoins = [Coin]()
    let searchController = UISearchController(searchResultsController: nil)
    var keyboardIsShown = false
    
    @IBOutlet weak var coinListTableView : UITableView!
    @IBOutlet weak var okButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        progressView = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressView.mode = MBProgressHUDMode.indeterminate
        progressView.label.text = Strings.get("Loading")
        
        progressView.show(animated: true)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Strings.get("Coins_List_Title")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        self.presenter?.fetchCoinList({ [weak self] (result : CoinListFetcher.CoinListResult) in
            DispatchQueue.main.async {
                switch (result) {
                    case .success(let coinList):
                        let userCoins = self?.presenter?.getUserCoins()
                        self?.coinList = coinList.filter({ (coin) -> Bool in
                            return !(userCoins?.contains(where: { (userCoin) -> Bool in
                                return userCoin.coin == coin;
                            }))!
                        })
                        self?.coinListLoaded()
                        break
                    case .failure(let error):
                        self?.progressView.label.text = "ERROR FETCHING COINS"
                        break
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardEvents()
        refreshOkButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterForKeyboardEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didHitOk(_ sender: AnyObject) {
        delegate?.onCoinsSelected(coins: selectedCoins)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return self.filteredCoins.count
        }
        
        return self.coinList.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isFiltering() {
            selectedCoins = selectedCoins.filter { $0 != filteredCoins[indexPath.row] }
        } else {
            selectedCoins = selectedCoins.filter { $0 != coinList[indexPath.row] }
        }
        refreshOkButton()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            selectedCoins.append(filteredCoins[indexPath.row])
        } else {
            selectedCoins.append(coinList[indexPath.row])   
        }
        refreshOkButton()
    }
    
    func refreshOkButton() {
        self.okButton.isUserInteractionEnabled = !selectedCoins.isEmpty
        self.okButton.alpha = selectedCoins.isEmpty ? 0.3 : 1.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinListCellIdentifier, for: indexPath)
        let coin : Coin
        if isFiltering() {
            coin = filteredCoins[indexPath.row]
        } else {
            coin = coinList[indexPath.row]
        }
        cell.textLabel?.text = coin.fullname
        //cell.detailTextLabel?.text = coin[indexPath.row].sym
        return cell
    }
    
    // MARK: Private methods
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCoins = self.coinList.filter({( coin : Coin) -> Bool in
            if searchBarIsEmpty() {
                return true
            } else {
                return coin.fullname.lowercased().contains(searchText.lowercased())
            }
        })
        self.coinListTableView?.reloadData()
    }
    
    
    func coinListLoaded() {
        self.progressView.hide(animated: true)
        
        self.coinListTableView.reloadData()
    }
    
    // MARK: Keyboard handler
    func registerForKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: .UIKeyboardDidHide, object: nil)
    }
    
    func unregisterForKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    
    @objc
    func keyboardShown(notification: Notification) {
        guard !keyboardIsShown else {
            return
        }
        keyboardIsShown = true
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.1, animations: {
                self.okButton.frame.origin.y -= keyboardSize.height;
            })
        }
    }
    
    @objc
    func keyboardHidden(notification: Notification) {
        guard keyboardIsShown else {
            return
        }
        keyboardIsShown = false
        /*UIView.animate(withDuration: 0.1, animations: {
            if let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                self.okButton.frame.origin.y += keyboardSize.height;
            }
        });*/
    }
}

extension CoinListViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension CoinListViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
