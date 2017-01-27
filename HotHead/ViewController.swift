//
//  ViewController.swift
//  HotHead
//
//  Created by Anthony Chika on 1/26/17.
//
//

import UIKit
import Charts

class ViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var txtRequestTime: UITextField!
    @IBOutlet weak var txtUrl: UITextField!
    @IBOutlet weak var chartCHT: LineChartView!
    @IBOutlet weak var chartEGT: LineChartView!
    
    var dataClient = DataClient(baseUrl: baseUrl, allowInvalidCert: true)
    var engineTemps:[EngineTemps?] = []
    let maxNumberOfPoints = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        txtUrl.text = baseUrl
        
        initializeCHTChart()
        initializeEGTChart()
        
        for _ in 0...maxNumberOfPoints-1 {
            engineTemps.append(nil)
        }
        
        //setup timer to run every 1 minute
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(requestUpdatedInfo), userInfo: nil, repeats: true)
    }
    
    func requestUpdatedInfo() {
        
        txtRequestTime.text = String(NSDate())
        
        dataClient.requestEngineTemps { (data, error) in
            if let err = error {
                print(err.localizedDescription)
            }
            else {
                print("SUCCESSFULLY RECEIVED \n\n \(data!.toJSONString(true)!)")
                self.engineTemps.append(data!)
                
                //truncate number of data points
                var min = 0
                if self.engineTemps.count > self.maxNumberOfPoints {
                    min = self.engineTemps.count - self.maxNumberOfPoints
                }
                self.engineTemps = Array(self.engineTemps[min..<self.engineTemps.count])
                self.updateChartView()
            }
        }
    }
    
    func updateChartView() {
        
        chartCHT.data = getCHTChartDataWithTimeScale()
        chartCHT.setNeedsDisplay()
        
        chartEGT.data = getEGTChartDataWithTimeScale()
        chartEGT.setNeedsDisplay()

    }
    
    func initializeCHTChart(){
        chartCHT.delegate = self
        
        chartCHT.clearDescriptionText()
        
        chartCHT.setTouch()
        
        chartCHT.setXYAxis()
        
        chartCHT.setMarker()
        
        chartCHT.setLegend()
        
        chartCHT.leftAxis.axisMinValue = 300
        chartCHT.leftAxis.axisMaxValue = 450
        
        let ll1 = ChartLimitLine(limit: 120.0, label: "Upper Limit")
        ll1.lineWidth = 4.0
        ll1.lineDashLengths = [5.0, 5.0]
        ll1.labelPosition = .RightTop
        
        let ll2 = ChartLimitLine(limit: 60.0, label: "Lower Limit")
        ll2.lineWidth = 4.0
        ll2.lineDashLengths = [5.0, 5.0]
        ll2.labelPosition = .RightBottom
        
        let leftAxis = chartCHT.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.addLimitLine(ll2)
    }
    
    func initializeEGTChart(){
        chartEGT.delegate = self
        
        chartEGT.clearDescriptionText()
        
        chartEGT.setTouch()
        
        chartEGT.setXYAxis()
        
        chartEGT.setMarker()
        
        chartEGT.setLegend()
        
        chartEGT.leftAxis.axisMinValue = 300
        chartEGT.leftAxis.axisMaxValue = 450
        
        let ll1 = ChartLimitLine(limit: 480.0, label: "Upper Limit")
        ll1.lineWidth = 4.0
        ll1.lineDashLengths = [5.0, 5.0]
        ll1.labelPosition = .RightTop
        
        let ll2 = ChartLimitLine(limit: 160.0, label: "Lower Limit")
        ll2.lineWidth = 4.0
        ll2.lineDashLengths = [5.0, 5.0]
        ll2.labelPosition = .RightBottom
        
        let leftAxis = chartEGT.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.addLimitLine(ll2)
    }

    func getCHTChartDataWithTimeScale() -> LineChartData {
        var dataSets:[LineChartDataSet] = []
        
        var allYVals:[ChartDataEntry] = []
        var xVals:[NSObject] = []
        for _ in 0...(engineTemps.count-1) {
            xVals.append("")
        }
        
        for cylinderIndex in 1...6 {
            
            var lineColor = UIColor.blackColor()
            switch cylinderIndex {
            case 1:
                lineColor = UIColor.redColor()
            case 2:
                lineColor = UIColor.greenColor()
            case 3:
                lineColor = UIColor.blueColor()
            case 4:
                lineColor = UIColor.yellowColor()
            case 5:
                lineColor = UIColor.orangeColor()
            case 6:
                lineColor = UIColor.purpleColor()
            default:
                lineColor = UIColor.blackColor()
            }
            
            var yVals:[ChartDataEntry] = []
            var xindex:Int = 0
            for temp in engineTemps {
                
                if let t = temp {

                    var val = 0
                    switch cylinderIndex {
                    case 1:
                        val = t.cht1
                    case 2:
                        val = t.cht2
                    case 3:
                        val = t.cht3
                    case 4:
                        val = t.cht4
                    case 5:
                        val = t.cht5
                    case 6:
                        val = t.cht6
                    default:
                        0
                    }
                    
                    let entry = ChartDataEntry(value: Double(val), xIndex: xindex, data:t)
                    yVals.append(entry)
                    allYVals.append(entry)
                }
                
                xindex += 1
            }
            
            chartCHT.leftAxis.drawLabelsEnabled = (yVals.count > 0)
            if yVals.count > 0 {
                let set1:LineChartDataSet = LineChartDataSet(yVals: yVals, label: "CHT \(cylinderIndex)")
                chartCHT.applyDataSetStyling(set1, circleColor:lineColor, lineColor:lineColor, showFill:false)
                dataSets.append(set1)
                
            }
            
        }
        
        chartCHT.calculateChartYAxis(allYVals, topBottomBufferPercent:20, lowerLimit: 40, upperLimit: 150)
        
        return LineChartData(xVals: xVals, dataSets: dataSets)
    }
    
    func getEGTChartDataWithTimeScale() -> LineChartData {
        var dataSets:[LineChartDataSet] = []
        
        var allYVals:[ChartDataEntry] = []
        var xVals:[NSObject] = []
        for _ in 0...(engineTemps.count-1) {
            xVals.append("")
        }
        
        for cylinderIndex in 1...6 {
            
            var lineColor = UIColor.blackColor()
            switch cylinderIndex {
            case 1:
                lineColor = UIColor.redColor()
            case 2:
                lineColor = UIColor.greenColor()
            case 3:
                lineColor = UIColor.blueColor()
            case 4:
                lineColor = UIColor.yellowColor()
            case 5:
                lineColor = UIColor.orangeColor()
            case 6:
                lineColor = UIColor.purpleColor()
            default:
                lineColor = UIColor.blackColor()
            }
            
            var yVals:[ChartDataEntry] = []
            var xindex:Int = 0
            for temp in engineTemps {
                
                if let t = temp {
                    var val = 0
                    switch cylinderIndex {
                    case 1:
                        val = t.egt1
                    case 2:
                        val = t.egt2
                    case 3:
                        val = t.egt3
                    case 4:
                        val = t.egt4
                    case 5:
                        val = t.egt5
                    case 6:
                        val = t.egt6
                    default:
                        0
                    }
                    
                    let entry = ChartDataEntry(value: Double(val), xIndex: xindex, data:t)
                    yVals.append(entry)
                    allYVals.append(entry)
                }
                
                xindex += 1
            }
            
            chartEGT.leftAxis.drawLabelsEnabled = (yVals.count > 0)
            if yVals.count > 0 {
                let set1:LineChartDataSet = LineChartDataSet(yVals: yVals, label: "EGT \(cylinderIndex)")
                chartEGT.applyDataSetStyling(set1, circleColor:lineColor, lineColor:lineColor, showFill:false)
                dataSets.append(set1)
                
            }
            
        }
        
        chartEGT.calculateChartYAxis(allYVals, topBottomBufferPercent:20, lowerLimit: 120, upperLimit: 500)
        
        return LineChartData(xVals: xVals, dataSets: dataSets)
    }

}

