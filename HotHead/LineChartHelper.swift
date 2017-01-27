//
//  LineChartHelper.swift
//  HotHead
//
//  Created by Anthony Chika on 1/26/17.
//
//

import Foundation
import Charts

extension LineChartView {
    
    func clearDescriptionText(){
        self.descriptionText = "";
        self.noDataTextDescription = "";
    }
    
    func setTouch(){
        self.dragEnabled = true
        self.setScaleEnabled(true)
        self.pinchZoomEnabled = false
        self.doubleTapToZoomEnabled = false
        self.drawGridBackgroundEnabled = true
    }
    
    func setXYAxis(){
        let leftAxis:ChartYAxis = self.leftAxis
        leftAxis.minWidth = 35 //fix the value range width so the multiple graphs don't var in x position to the right of the values
        leftAxis.maxWidth = 35 //fix the value range width so the multiple graphs don't var in x position to the right of the values
        leftAxis.startAtZeroEnabled = false
        leftAxis.gridLineDashLengths = [5.0, 5.0]
        leftAxis.drawGridLinesEnabled = false
        leftAxis.valueFormatter = NSNumberFormatter()
        leftAxis.valueFormatter?.numberStyle = .DecimalStyle //default to a single digit after number, chart seems to automatically determine if it's needed or not
        
        //        leftAxis.spaceTop = 0.2 //provide a little extra space on top and bottom so points don't hug the borders
        //        leftAxis.spaceBottom = 0.2
        
        let xAxis:ChartXAxis = self.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = false
        
        self.rightAxis.enabled = false
        
        //this setting is used to allow the pinch and zoom to scale up to x amount the original size
        self.viewPortHandler.setMaximumScaleY(2.0)
        self.viewPortHandler.setMaximumScaleX(2.0)
    }
    
    func setMarker(){
        let marker = ChartSelectionMarker(color: UIColor.blackColor())
        marker.minimumSize = CGSizeMake(14.0, 7.0)
        self.marker = marker
        self.marker = nil
    }
    
    func setLegend(){
        //no need for chart legend right now
        self.legend.form = ChartLegend.Form.Line
        self.legend.enabled = true
    }
    
    //this method is here to do a better job at determining the yAxis values
    func calculateChartYAxis(yVals: [ChartDataEntry], topBottomBufferPercent:Int, lowerLimit:Double, upperLimit:Double) {
        var maxValue:Double?
        var minValue:Double?
        
        for entry:ChartDataEntry in yVals {
            
            //determine min an max
            if minValue == nil || entry.value < minValue {
                minValue = entry.value
            }
            if maxValue == nil || entry.value > maxValue {
                maxValue = entry.value
            }
        }
        
        if maxValue != nil && minValue != nil && maxValue != minValue {
            var buffer:Double = 0
            if topBottomBufferPercent > 0 {
                buffer = (maxValue! - minValue!) * Double(topBottomBufferPercent)/100
            }
            
            minValue = minValue! - buffer
            maxValue = maxValue! + buffer
            
            if minValue > lowerLimit {
                minValue = lowerLimit
            }
            
            if maxValue < upperLimit {
                maxValue = upperLimit
            }
            
            self.leftAxis.axisMinValue = minValue! // customAxisMin
            self.leftAxis.axisMaxValue = maxValue! // customAxisMax
        }
        else {
            self.leftAxis.resetCustomAxisMin()
            self.leftAxis.resetCustomAxisMax()
        }
    }
    
    func applyDataSetStyling(set:LineChartDataSet, circleColor:UIColor, lineColor:UIColor, showFill:Bool) {
        
        set.drawValuesEnabled = false
        //set.lineDashLengths = [5.0, 2.5]
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawVerticalHighlightIndicatorEnabled = true
        set.highlightEnabled = true
        set.highlightLineDashLengths = [5.0, 2.5]
        set.highlightLineWidth = 0.5 //hide the highlight line
        set.setColor(lineColor)
        set.setCircleColor(circleColor)
        set.lineWidth = 1.0
        set.circleRadius = 4.5
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.valueFont = UIFont.systemFontOfSize(9.0)
        
        //        set.fillAlpha = 25/255.0
        //        set.fillColor = UIColor.blackColor()
        
        //        //set gradient
        let gradientColors:CFArray = [
            ChartColorTemplates.colorFromString("#F0F0F0").CGColor,
            ChartColorTemplates.colorFromString("#737373").CGColor
        ]
        let gradient:CGGradientRef = CGGradientCreateWithColors(nil, gradientColors, nil)!
        
        set.fillAlpha = 1.0
        set.fill = ChartFill(linearGradient: gradient, angle: 90.0)
        set.drawFilledEnabled = showFill
    }
}