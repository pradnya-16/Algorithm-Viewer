# 📊 Algorithm Viewer - iOS App

An iOS application built using **Xcode 15** and **Storyboard**, designed to animate and visually compare sorting algorithms side by side using GCD-based multithreading.

---

## 🚀 Features

- 🔄 Animates 4 sorting algorithms:
  - Insertion Sort
  - Selection Sort
  - Merge Sort
  - Quick Sort
- 🧠 Visual comparison of two algorithms at once
- 📊 Custom chart view (`ChartView`) with smooth bar animations
- 🎨 Real-time highlighting of active comparisons in red
- ⚙️ Concurrent execution using **Grand Central Dispatch (GCD)**
- 🧼 Clean and responsive UI built with **Storyboard** and `UISegmentedControl`

---

## 📱 UI Components

- **Segmented Controls** for:
  - Sample sizes (`16`, `32`, `48`, `64`)
  - Algorithm pickers (top and bottom)
- **Sort Button** to start sorting and disable UI during execution
- **Two `ChartView`s** for animated visualization
- Highlights comparison/swapping bars in **red**

---

## 🛠 Technologies

- Xcode 15.x
- Swift 5
- UIKit
- Storyboard (No SwiftUI)
- GCD (Multithreading)
- Custom `UIView` for chart animation

---

## 🗂 Project Structure

AlgorithmViewer/ ├── ChartView.swift # Custom chart drawing logic ├── ViewController.swift # Main logic and multithreading ├── SortingAlgorithm.swift # Enum for algorithm types ├── Main.storyboard # UI layout using Storyboard ├── Assets.xcassets/ # Includes AppIcon and UI assets ├── Info.plist


---

## 🧪 How to Run

1. Clone or download this repository.
2. Open the `.xcodeproj` in Xcode 15.
3. Select an iPhone simulator (e.g. iPhone 15).
4. Build and run the app (`Cmd + R`).

---

## ✅ Project Requirements Checklist

- [x] Sorting with GCD (background thread)
- [x] Uses custom view for chart animation
- [x] Implements all required UI controls
- [x] Highlights active comparison indices
- [x] Responsive, clean, and documented code
- [x] Uses Storyboard and not SwiftUI

---

## 📎 Author

**Pradnya Kadam**  
Spring 2025  
