//
//  CoinSummaryCell.swift
//  plutus
//
//  Created by Eddie Long on 08/02/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import UIKit
import SDWebImage
import Charts

protocol CellDelegate : class {
    func didChangePeriod(sender: CoinSummaryCell, period: PricePeriod)
}

class CoinSummaryCell : UITableViewCell {
    
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var price : UILabel!
    @IBOutlet weak var percentage : UILabel!
    @IBOutlet weak var coinImage : UIImageView!
    @IBOutlet weak var chart : LineChartView!
    
    private var period = PricePeriod.last24
    
    weak var cellDelegate: CellDelegate? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func sliderChanged(sender : PSegmentedControl) {
        switch (sender.selectedIndex) {
        case 0:
            periodChanged(.last24)
            break
        case 1:
            periodChanged(.week)
            break
        case 2:
            periodChanged(.month)
            break
        case 3:
            periodChanged(.year)
            break
        case 4:
            periodChanged(.allTime)
            break
        default:
            periodChanged(.allTime)
            break
        }
    }
    
    private func periodChanged(_ newPeriod : PricePeriod) {
        if (self.period != newPeriod) {
            self.cellDelegate?.didChangePeriod(sender: self, period: newPeriod)
        }
    }
    
    func setCoin24HourData(coin : UserCoin) {
        //updatePeriodText()
        name.text = coin.coin.fullname
        price.text = coin.currentPrice.price
        percentage.text = "\(coin.currentPrice.change24Hour.changePercent)%"
        if let percentageValue = Float(coin.currentPrice.change24Hour.changePercent) {
            if (percentageValue > 0.0) {
                percentage.textColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
            } else if (percentageValue < 0.0) {
                percentage.textColor = UIColor.red
            } else {
                percentage.textColor = UIColor.black
            }
        }
        
        //updatePeriodText()
        
        if let url = URL.init(string: "https://www.cryptocompare.com" +  coin.coin.imageUrl) {
            coinImage.sd_setImage(with: url, completed: nil)
        }
    }
    
    private func setCoinData(_ coinData : CoinPricePeriod, _ period : PricePeriod) {
        if let chartView = chart {
            self.period = period
            chartView.isHidden = false
            // Do any additional setup after loading the view.
            //chartView.delegate = self
            var max = Float.leastNormalMagnitude
            var min = Float.greatestFiniteMagnitude
            for pricePoint in coinData.prices {
                max = Float.maximum(pricePoint.close, max)
                min = Float.minimum(pricePoint.close, min)
            }
            
            chartView.chartDescription?.enabled = false
            chartView.dragEnabled = false
            chartView.setScaleEnabled(false)
            chartView.pinchZoomEnabled = false
            chartView.drawMarkers = true
            
            let xAxis = chartView.xAxis
            xAxis.drawAxisLineEnabled = false
            xAxis.drawGridLinesEnabled = false
            xAxis.drawLabelsEnabled = true
            xAxis.centerAxisLabelsEnabled = true
            xAxis.granularity = 3600
            xAxis.xOffset = 0
            
            let leftAxis = chartView.leftAxis
            leftAxis.labelPosition = .outsideChart
            leftAxis.drawGridLinesEnabled = false
            leftAxis.granularityEnabled = false
            leftAxis.drawLabelsEnabled = true
            leftAxis.drawAxisLineEnabled = true
            leftAxis.axisMinimum = Double(min - ((max - min) * 0.1))
            leftAxis.axisMaximum = Double(max + ((max - min) * 0.1))
            
            chartView.rightAxis.enabled = false

            chartView.legend.form = .none
            chartView.animate(xAxisDuration: 2.5)
        }
    }
    
    public func setCoinPrices(_ coinData : CoinPricePeriod?, _ period : PricePeriod) {
        guard let coinPrices = coinData else {
            return;
        }
        setCoinData(coinPrices, period)
        
        var entries = [ChartDataEntry]()
        for price in coinPrices.prices {
            entries.append(ChartDataEntry(x: Double(price.timestamp), y: Double(price.close)))
        }
        
        let set1 = LineChartDataSet(values: entries, label: "")
        set1.axisDependency = .left
        set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        set1.lineWidth = 1.5
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = true
        set1.fillAlpha = 0.26
        set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        
        let chartFormatter = PeriodAxisChartFormatter(period: period)
        let xAxis = XAxis()
        
        xAxis.valueFormatter = chartFormatter
        
        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.darkGray)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        
        if let chartView = chart {
            chartView.xAxis.valueFormatter = xAxis.valueFormatter
            chartView.data = data
        }
    }
    
}
