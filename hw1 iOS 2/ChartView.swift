//
//  ChartView.swift
//  hw1 iOS 2
//
//  Created by Pradnya Kadam on 4/17/25.
//

import UIKit

class ChartView: UIView {
    var values: [Int] = [] {
        didSet { setNeedsDisplay() }
    }

    var highlightIndices: [Int] = [] {
        didSet { setNeedsDisplay() }
    }

    var barColor: UIColor = .systemTeal

    override func draw(_ rect: CGRect) {
        guard !values.isEmpty else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let width = rect.width / CGFloat(values.count)
        let maxVal = values.max() ?? 1

        for (i, value) in values.enumerated() {
            let barHeight = CGFloat(value) / CGFloat(maxVal) * rect.height
            let barRect = CGRect(x: CGFloat(i) * width,
                                 y: rect.height - barHeight,
                                 width: width - 1,
                                 height: barHeight)

            let isHighlighted = highlightIndices.contains(i)
            context.setFillColor((isHighlighted ? UIColor.systemRed : barColor).cgColor)
            context.fill(barRect)
        }
    }
}

