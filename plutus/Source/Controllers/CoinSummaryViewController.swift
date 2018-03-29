//
//  ViewController.swift
//  plutus
//
//  Created by Eddie Long on 15/01/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import UIKit
import MBProgressHUD
import SWLogger

class CoinSummaryViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, CoinListViewDelegate, CellDelegate {

    @IBOutlet weak var coinListTableView : UITableView!
    let CoinSummaryCellIdentifier = "coin_summary_item"
    let coinPresenter = CoinPresenter()
    var progressView = MBProgressHUD()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        progressView = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressView.mode = MBProgressHUDMode.indeterminate
        progressView.label.text = Strings.get("Loading")
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        self.refreshControl.backgroundColor = UIColor.lightGray
        self.refreshControl.tintColor = UIColor.black
        self.refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        self.coinListTableView.refreshControl = self.refreshControl
        
        refreshContent()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    private func refreshContent() {
        
        progressView.show(animated: true)
        
        let coinsToFetch = coinPresenter.getUserCoins().flatMap{$0.coin};
        coinPresenter.fetchCoinPrices(coins: coinsToFetch, currencies: [Config.defaultCurrency], { [weak self] (result : CoinCurrentMarketInfoFetcher.CoinPriceResult) in
            DispatchQueue.main.async {
                switch (result) {
                case .success(let coinPrices):
                    self?.coinListTableView.reloadData()
                    self?.progressView.hide(animated: true)
                    self?.refreshControl.endRefreshing()
                    break
                case .failure(let error):
                    self?.progressView.hide(animated: true)
                    // TODO: handle error
                    break
                }
            }
        })
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        self.coinListTableView.setEditing(editing, animated: animated)
        super.setEditing(editing, animated: animated)
    }
    
    @IBAction func addCoins() {
        //self.performSegue(withIdentifier: "SelectCoins", sender: self);
        if let coinListVC = self.storyboard?.instantiateViewController(withIdentifier: "CoinList") as? CoinListViewController {
            coinListVC.presenter = coinPresenter
            coinListVC.delegate = self
            self.navigationController?.pushViewController(coinListVC, animated: true)
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coinPresenter.getUserCoins().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.coinPresenter.moveUserCoin(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinSummaryCellIdentifier, for: indexPath) as! CoinSummaryCell
        let userCoin = self.coinPresenter.getUserCoins()[indexPath.row]
        let period = PricePeriod.last24
        cell.setCoin24HourData(coin: userCoin)
        cell.cellDelegate = self
        loadCellData(cell, period, indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.coinPresenter.removeUserCoin(self.coinPresenter.getUserCoins()[indexPath.row])
            if (self.coinPresenter.getUserCoins().count == 0) {
                tableView.deleteSections([indexPath.section], with: .fade)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        
        return .none
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    // MARK: CoinListViewDelegate
    
    func onCoinsSelected(coins : [Coin]) {
        self.navigationController?.popViewController(animated: true)
        progressView.show(animated: true)
        
        if let tableView = self.coinListTableView {
            let numRows = Int(tableView.numberOfRows(inSection: 0))
            self.coinPresenter.addCoinsToUser(coins) { [weak self] (result) in
                self?.progressView.hide(animated: true)
                
                tableView.beginUpdates()
                var indexPaths = [IndexPath]()
                for newIndex in 0..<coins.count {
                    indexPaths.append(IndexPath.init(row: numRows + newIndex, section: 0));
                    tableView.insertRows(at: indexPaths, with: .automatic)
                }
                tableView.endUpdates()
                tableView.scrollToRow(at: IndexPath.init(row: numRows + coins.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    // MARK: SwipeDelegate
    
    func didChangePeriod(sender: CoinSummaryCell, period: PricePeriod) {
        if let indexPath = self.coinListTableView.indexPath(for: sender) {
            loadCellData(sender, period, indexPath)
        }
    }
    
    func loadCellData(_ cell: CoinSummaryCell, _ period: PricePeriod, _ indexPath : IndexPath) {
        let userCoin = self.coinPresenter.getUserCoins()[indexPath.row]
        self.coinPresenter.fetchHistoricalData(userCoin.coin, period) { result in
            switch (result) {
            case .success(let historicalData):
                // TODO: Validate this is the right cell
                cell.setCoinPrices(historicalData, period)
                break
            case .failure(let error):
                break;
            }
        }
    }
}

