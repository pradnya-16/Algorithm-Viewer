

import UIKit

// MARK: - ViewController
class ViewController: UIViewController {

    @IBOutlet weak var sampleSizePicker: UISegmentedControl!
    @IBOutlet weak var algorithmPicker1: UISegmentedControl!
    @IBOutlet weak var algorithmPicker2: UISegmentedControl!
    @IBOutlet weak var chartView1: ChartView!
    @IBOutlet weak var chartView2: ChartView!
    @IBOutlet weak var sortButton: UIButton!

    let sampleSizes = [16, 32, 48, 64]
    let algorithms = SortingAlgorithm.allCases

    var data1: [Int] = []
    var data2: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControls()
        chartView1.barColor = .systemGreen
        chartView2.barColor = .systemOrange
        generateArrays(for: sampleSizes[sampleSizePicker.selectedSegmentIndex])
    }

    func setupSegmentedControls() {
        sampleSizePicker.removeAllSegments()
        for (index, size) in sampleSizes.enumerated() {
            sampleSizePicker.insertSegment(withTitle: "\(size)", at: index, animated: false)
        }
        sampleSizePicker.selectedSegmentIndex = 0
        sampleSizePicker.addTarget(self, action: #selector(sampleSizeChanged), for: .valueChanged)

        algorithmPicker1.removeAllSegments()
        algorithmPicker2.removeAllSegments()
        for (index, algo) in algorithms.enumerated() {
            algorithmPicker1.insertSegment(withTitle: algo.rawValue, at: index, animated: false)
            algorithmPicker2.insertSegment(withTitle: algo.rawValue, at: index, animated: false)
        }
        algorithmPicker1.selectedSegmentIndex = 0
        algorithmPicker2.selectedSegmentIndex = 0
    }

    @objc func sampleSizeChanged() {
        let size = sampleSizes[sampleSizePicker.selectedSegmentIndex]
        generateArrays(for: size)
    }

    func generateArrays(for size: Int) {
        data1 = Array(1...size).shuffled()
        data2 = Array(1...size).shuffled()
        chartView1.values = data1
        chartView2.values = data2
    }

    @IBAction func sortTapped(_ sender: UIButton) {
        disableUI()

        let algo1 = algorithms[algorithmPicker1.selectedSegmentIndex]
        let algo2 = algorithms[algorithmPicker2.selectedSegmentIndex]

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.sort(&self.data1, algorithm: algo1) { array, highlights in
                DispatchQueue.main.async {
                    self.chartView1.values = array
                    self.chartView1.highlightIndices = highlights
                }
                usleep(200_000)
            }
            DispatchQueue.main.async {
                self.chartView1.highlightIndices = []
                self.enableUI()
            }
        }

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.sort(&self.data2, algorithm: algo2) { array, highlights in
                DispatchQueue.main.async {
                    self.chartView2.values = array
                    self.chartView2.highlightIndices = highlights
                }
                usleep(200_000)
            }
            DispatchQueue.main.async {
                self.chartView2.highlightIndices = []
            }
        }
    }

    func sort(_ array: inout [Int], algorithm: SortingAlgorithm, stepHandler: @escaping ([Int], [Int]) -> Void) {
        switch algorithm {
        case .insertion:
            insertionSort(&array, stepHandler)
        case .selection:
            selectionSort(&array, stepHandler)
        case .merge:
            mergeSort(&array, stepHandler)
        case .quick:
            quickSort(&array, low: 0, high: array.count - 1, stepHandler)
        }
    }

    func insertionSort(_ array: inout [Int], _ step: @escaping ([Int], [Int]) -> Void) {
        for i in 1..<array.count {
            var j = i
            while j > 0 && array[j] < array[j - 1] {
                array.swapAt(j, j - 1)
                step(array, [j, j - 1])
                j -= 1
            }
        }
    }

    func selectionSort(_ array: inout [Int], _ step: @escaping ([Int], [Int]) -> Void) {
        for i in 0..<array.count {
            var minIndex = i
            for j in i + 1..<array.count {
                step(array, [j, minIndex])
                if array[j] < array[minIndex] {
                    minIndex = j
                }
            }
            if i != minIndex {
                array.swapAt(i, minIndex)
                step(array, [i, minIndex])
            }
        }
    }

    func mergeSort(_ array: inout [Int], _ step: @escaping ([Int], [Int]) -> Void) {
        func merge(_ left: Int, _ middle: Int, _ right: Int) {
            let leftArray = Array(array[left...middle])
            let rightArray = Array(array[(middle + 1)...right])
            var i = 0, j = 0, k = left

            while i < leftArray.count && j < rightArray.count {
                step(array, [k])
                if leftArray[i] <= rightArray[j] {
                    array[k] = leftArray[i]; i += 1
                } else {
                    array[k] = rightArray[j]; j += 1
                }
                step(array, [k])
                k += 1
            }

            while i < leftArray.count {
                array[k] = leftArray[i]; i += 1; step(array, [k]); k += 1
            }

            while j < rightArray.count {
                array[k] = rightArray[j]; j += 1; step(array, [k]); k += 1
            }
        }

        func mergeSortHelper(_ left: Int, _ right: Int) {
            if left < right {
                let middle = (left + right) / 2
                mergeSortHelper(left, middle)
                mergeSortHelper(middle + 1, right)
                merge(left, middle, right)
            }
        }

        mergeSortHelper(0, array.count - 1)
    }

    func quickSort(_ array: inout [Int], low: Int, high: Int, _ step: @escaping ([Int], [Int]) -> Void) {
        if low < high {
            let pivot = partition(&array, low: low, high: high, step)
            quickSort(&array, low: low, high: pivot - 1, step)
            quickSort(&array, low: pivot + 1, high: high, step)
        }
    }

    func partition(_ array: inout [Int], low: Int, high: Int, _ step: @escaping ([Int], [Int]) -> Void) -> Int {
        let pivot = array[high]
        var i = low

        for j in low..<high {
            step(array, [j, high])
            if array[j] < pivot {
                array.swapAt(i, j)
                step(array, [i, j])
                i += 1
            }
        }
        array.swapAt(i, high)
        step(array, [i, high])
        return i
    }

    func disableUI() {
        sortButton.isEnabled = false
        sampleSizePicker.isEnabled = false
        algorithmPicker1.isEnabled = false
        algorithmPicker2.isEnabled = false
    }

    func enableUI() {
        sortButton.isEnabled = true
        sampleSizePicker.isEnabled = true
        algorithmPicker1.isEnabled = true
        algorithmPicker2.isEnabled = true
    }
}
