//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 19/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

import Foundation
import UIKit;
import Charts;

public class ChartSelectionMarker: ChartMarker
{
    public var color: UIColor?
    public var minimumSize = CGSize()
    
    private var _size: CGSize = CGSize()
    
    public init(color: UIColor)
    {
        super.init()
        
        self.color = color
    }
    
    public override var size: CGSize { return _size; }
    
    public override func draw(context context: CGContext, point: CGPoint)
    {
        var startAngle: Float = Float(2 * M_PI)
        var endAngle: Float = 0.0
        
        // Drawing code
        // Set the radius
        let strokeWidth = 1.0
        let radius = CGFloat((CGFloat(_size.width) - CGFloat(strokeWidth)) / 2)
        
        // Get the context
        let context = UIGraphicsGetCurrentContext()
        
        // Find the middle of the circle
        //let center = CGPointMake(rect.size.width / 2, rect.size.height / 2)
        
        // Set the stroke color
        CGContextSetStrokeColorWithColor(context, color?.CGColor)
        
        // Set the line width
        CGContextSetLineWidth(context, CGFloat(strokeWidth))
        
        // Set the fill color (if you are filling the circle)
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        
        // Rotate the angles so that the inputted angles are intuitive like the clock face: the top is 0 (or 2π), the right is π/2, the bottom is π and the left is 3π/2.
        // In essence, this appears like a unit circle rotated π/2 anti clockwise.
        startAngle = startAngle - Float(M_PI_2)
        endAngle = endAngle - Float(M_PI_2)
        
        // Draw the arc around the circle
        CGContextAddArc(context, point.x, point.y, CGFloat(radius), CGFloat(startAngle), CGFloat(endAngle), 0)
        
        // Draw the arc
        CGContextDrawPath(context, .FillStroke) // or kCGPathFillStroke to fill and stroke the circle
        
    }
    
    public override func refreshContent(entry entry: ChartDataEntry, highlight: ChartHighlight)
    {
        _size.width = max(minimumSize.width, _size.width)
        _size.height = max(minimumSize.height, _size.height)
    }
}