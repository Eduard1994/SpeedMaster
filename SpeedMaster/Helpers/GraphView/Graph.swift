//
//  Graph.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/28/21.
//

import UIKit

class Graph: ScrollableGraphViewDataSource {
    
    var data: [Double]
    
    init(data: [Double]) {
        self.data = data
    }
    
    func createBarGraph(_ frame: CGRect) -> ScrollableGraphView {
        
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        
        // Setup the plot
        let barPlot = BarPlot(identifier: "bar")
        
        barPlot.shouldRoundBarCorners = true
        barPlot.barWidth = 20
        barPlot.barLineWidth = 4
        barPlot.barLineColor = .mainYellow
        barPlot.barColor = .mainYellow
        
        barPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        barPlot.animationDuration = 1.5
        
        // Setup the graph
        graphView.backgroundFillColor = .clear
        graphView.dataPointSpacing = 15
        
        graphView.shouldAnimateOnStartup = true
        
        graphView.rangeMax = data.maximum()
        graphView.rangeMin = data.minimum()
        
        // Add everything
        graphView.addPlot(plot: barPlot)
        return graphView
    }
    
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
            
        // Data for the graphs with a single plot
        case "bar":
            return data[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return ""
    }
    
    func numberOfPoints() -> Int {
        return data.count
    }
}
