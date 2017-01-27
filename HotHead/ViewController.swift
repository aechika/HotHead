//
//  ViewController.swift
//  HotHead
//
//  Created by Anthony Chika on 1/26/17.
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtServerResponse: UITextView!
    @IBOutlet weak var txtRequestTime: UITextField!
    @IBOutlet weak var txtUrl: UITextField!
    
    var dataClient = DataClient(baseUrl: baseUrl, allowInvalidCert: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        txtServerResponse.text = ""
        txtUrl.text = baseUrl
        
        //setup timer to run every 1 minute
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(requestUpdatedInfo), userInfo: nil, repeats: true)
    }
    
    func requestUpdatedInfo() {
        
        txtRequestTime.text = String(NSDate())
        
        dataClient.requestEngineTemps { (data, error) in
            if let err = error {
                self.txtServerResponse.text = err.localizedDescription
            }
            else {
                self.txtServerResponse.text = "SUCCESSFULLY RECEIVED \n\n \(data!.toJSONString(true))"
                self.updateChart(data!)
            }
        }
    }
    
    func updateChart(data:EngineTemps) {
        
    }
}

