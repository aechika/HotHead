//
//  ViewController.swift
//  HotHead
//
//  Created by Anthony Chika on 1/26/17.
//
//

import UIKit
import AVFoundation
import Charts


class ViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var chartCHT: LineChartView!
    @IBOutlet weak var chartEGT: LineChartView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnUrl: UIButton!
    
    @IBOutlet weak var vwAlertCHT1: UIView!
    @IBOutlet weak var vwAlertCHT2: UIView!
    @IBOutlet weak var vwAlertCHT3: UIView!
    @IBOutlet weak var vwAlertCHT4: UIView!
    @IBOutlet weak var vwAlertCHT5: UIView!
    @IBOutlet weak var vwAlertCHT6: UIView!
    
    @IBOutlet weak var vwAlertEGT1: UIView!
    @IBOutlet weak var vwAlertEGT2: UIView!
    @IBOutlet weak var vwAlertEGT3: UIView!
    @IBOutlet weak var vwAlertEGT4: UIView!
    @IBOutlet weak var vwAlertEGT5: UIView!
    @IBOutlet weak var vwAlertEGT6: UIView!
    
    
    var chtUpperThreshold:Int = 90
    var chtLowerThreshold:Int = 50
    var chtUpperMin:Int = 120
    var chtLowerMin:Int = 20

    var egtUpperThreshold:Int = 320
    var egtLowerThreshold:Int = 120
    var egtUpperMin:Int = 400
    var egtLowerMin:Int = 50
    
    
    var dataClient:DataClient?
    var engineTemps:[EngineTemps?] = []
    let maxNumberOfPoints = 30
    var timer:NSTimer?
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initializeChart(chartCHT, upperThreshold: chtUpperThreshold, lowerThreshold: chtLowerThreshold, upperMin: chtUpperMin, lowerMin: chtLowerMin)
        initializeChart(chartEGT, upperThreshold: egtUpperThreshold, lowerThreshold: egtLowerThreshold, upperMin: egtUpperMin, lowerMin: egtLowerMin)
        updateChartView()

        initializeView()
    }
    
    func initializeView() {
        
        timer = nil
        engineTemps.removeAll()
        for _ in 0...maxNumberOfPoints-1 {
            engineTemps.append(nil)
        }

        updateChartView()
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let baseUrl = defaults.objectForKey(UserDefaultKey_Base_Url) as? String {
          
            btnUrl.setTitle(baseUrl, forState: UIControlState.Normal)
            
            dataClient = DataClient(baseUrl: baseUrl, allowInvalidCert: true, isMock: isMock)
            
            //setup timer to run every 1 minute
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(requestUpdatedInfo), userInfo: nil, repeats: true)
            
        }
    }
    
    func requestUpdatedInfo() {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        lblTime.text = formatter.stringFromDate(NSDate())
        
        if let client = dataClient {
            client.requestEngineTemps { (data, error) in
                if let err = error {
                    print(err.localizedDescription)
                }
                else {
                    print("SUCCESSFULLY RECEIVED \n\n \(data!.toJSONString(true)!)")
                    self.newInfoReceived(data!)
                }
            }
        }
    }
    
    func newInfoReceived(data:EngineTemps) {
        
        self.engineTemps.append(data)
        
        //truncate number of data points
        var min = 0
        if self.engineTemps.count > self.maxNumberOfPoints {
            min = self.engineTemps.count - self.maxNumberOfPoints
        }
        self.engineTemps = Array(self.engineTemps[min..<self.engineTemps.count])
        
        //sort by timestamp
        self.engineTemps.sortInPlace {
            return $0?.timestamp < $1?.timestamp
        }
        
        self.updateAlerts(data)
        self.updateChartView()
    }
    
    func updateAlerts(data:EngineTemps) {
        
        updateAlertView(data.cht1, upperThreshold: chtUpperThreshold, lowerThreshold: chtLowerThreshold, view: vwAlertCHT1)
        updateAlertView(data.cht2, upperThreshold: chtUpperThreshold, lowerThreshold: chtLowerThreshold, view: vwAlertCHT2)
        updateAlertView(data.cht3, upperThreshold: chtUpperThreshold, lowerThreshold: chtLowerThreshold, view: vwAlertCHT3)
        updateAlertView(data.cht4, upperThreshold: chtUpperThreshold, lowerThreshold: chtLowerThreshold, view: vwAlertCHT4)
        updateAlertView(data.cht5, upperThreshold: chtUpperThreshold, lowerThreshold: chtLowerThreshold, view: vwAlertCHT5)
        updateAlertView(data.cht6, upperThreshold: chtUpperThreshold, lowerThreshold: chtLowerThreshold, view: vwAlertCHT6)
        
        updateAlertView(data.egt1, upperThreshold: egtUpperThreshold, lowerThreshold: egtLowerThreshold, view: vwAlertEGT1)
        updateAlertView(data.egt2, upperThreshold: egtUpperThreshold, lowerThreshold: egtLowerThreshold, view: vwAlertEGT2)
        updateAlertView(data.egt3, upperThreshold: egtUpperThreshold, lowerThreshold: egtLowerThreshold, view: vwAlertEGT3)
        updateAlertView(data.egt4, upperThreshold: egtUpperThreshold, lowerThreshold: egtLowerThreshold, view: vwAlertEGT4)
        updateAlertView(data.egt5, upperThreshold: egtUpperThreshold, lowerThreshold: egtLowerThreshold, view: vwAlertEGT5)
        updateAlertView(data.egt6, upperThreshold: egtUpperThreshold, lowerThreshold: egtLowerThreshold, view: vwAlertEGT6)
        
    }
    
    func updateAlertView(val:Int, upperThreshold:Int, lowerThreshold:Int, view:UIView) {
        
        if val >= upperThreshold || val <= lowerThreshold {
            view.backgroundColor = UIColor.redColor()
            playSound()
        }
        else {
            view.backgroundColor = UIColor.greenColor()
        }

    }
    
    func updateChartView() {
        
        chartCHT.data = getCHTChartDataWithTimeScale()
        chartCHT.setNeedsDisplay()
        
        chartEGT.data = getEGTChartDataWithTimeScale()
        chartEGT.setNeedsDisplay()

    }
    
    func getCHTChartDataWithTimeScale() -> LineChartData {
        var dataSets:[LineChartDataSet] = []
        
        var allYVals:[ChartDataEntry] = []
        var xVals:[NSObject] = []
        for _ in 0...(maxNumberOfPoints-1) {
            xVals.append("")
        }
        
        for cylinderIndex in 1...6 {
            
            var lineColor = UIColor.blackColor()
            switch cylinderIndex {
            case 1:
                lineColor = UIColor.whiteColor()
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
                let set1:LineChartDataSet = LineChartDataSet(yVals: yVals, label: "Cylinder \(cylinderIndex)")
                chartCHT.applyDataSetStyling(set1, circleColor:lineColor, lineColor:lineColor, showFill:false)
                dataSets.append(set1)
                
            }
            
        }
        
        chartCHT.calculateChartYAxis(allYVals, topBottomBufferPercent:20, lowerLimit: Double(chtLowerMin), upperLimit: Double(chtUpperMin))
        
        return LineChartData(xVals: xVals, dataSets: dataSets)
    }
    
    func getEGTChartDataWithTimeScale() -> LineChartData {
        var dataSets:[LineChartDataSet] = []
        
        var allYVals:[ChartDataEntry] = []
        var xVals:[NSObject] = []
        for _ in 0...(maxNumberOfPoints-1) {
            xVals.append("")
        }
        
        for cylinderIndex in 1...6 {
            
            var lineColor = UIColor.blackColor()
            switch cylinderIndex {
            case 1:
                lineColor = UIColor.whiteColor()
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
                let set1:LineChartDataSet = LineChartDataSet(yVals: yVals, label: "Cylinder \(cylinderIndex)")
                chartEGT.applyDataSetStyling(set1, circleColor:lineColor, lineColor:lineColor, showFill:false)
                dataSets.append(set1)
                
            }
            
        }
        
        chartEGT.calculateChartYAxis(allYVals, topBottomBufferPercent:20, lowerLimit: Double(egtLowerMin), upperLimit: Double(egtUpperMin))
        
        return LineChartData(xVals: xVals, dataSets: dataSets)
    }
    
    @IBAction func urlPressed(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Update URL", message: "Enter url", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = defaults.objectForKey(UserDefaultKey_Base_Url) as? String
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [weak alert] (action) -> Void in
            let textField = alert!.textFields![0] as UITextField
            
                defaults.setObject(textField.text, forKey: UserDefaultKey_Base_Url)
                self.initializeView()
            }))
        
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func initializeChart(chart:LineChartView, upperThreshold:Int, lowerThreshold:Int, upperMin:Int, lowerMin:Int){
        chart.delegate = self
        
        chart.backgroundColor = UIColor.blackColor()
        chart.gridBackgroundColor = UIColor.blackColor()
        
        chart.clearDescriptionText()
        
        chart.setTouch()
        
        chart.setXYAxis()
        
        chart.setMarker()
        
        chart.setLegend()
        
        chart.leftAxis.axisMinValue = Double(lowerMin)
        chart.leftAxis.axisMaxValue = Double(upperMin)
        
        let ll1 = ChartLimitLine(limit: Double(upperThreshold), label: "Upper Limit (\(upperThreshold)°F)")
        ll1.lineWidth = 4.0
        ll1.lineDashLengths = [5.0, 5.0]
        ll1.labelPosition = .RightTop
        
        let ll2 = ChartLimitLine(limit: Double(lowerThreshold), label: "Lower Limit (\(lowerThreshold)°F)")
        ll2.lineWidth = 4.0
        ll2.lineDashLengths = [5.0, 5.0]
        ll2.labelPosition = .RightBottom
        
        let leftAxis = chart.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.addLimitLine(ll2)
    }
    
    func playSound() {
        let url = NSBundle.mainBundle().URLForResource("beep-01a", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
}

