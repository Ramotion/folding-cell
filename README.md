<img src="https://github.com/Ramotion/folding-cell/blob/master/header.png">

<a href="https://github.com/Ramotion/folding-cell">
<img align="left" src="https://github.com/Ramotion/folding-cell/blob/master/Screenshots/foldingCell.gif" width="480" height="360" /></a>

<p><h1 align="left">FOLDING CELL</h1></p>

<h4>Expanding content cell with animation inspired by folding paper card material design.</h4>


___



<p><h6>We specialize in the designing and coding of custom UI for Mobile Apps and Websites.</h6>
<a href="https://dev.ramotion.com?utm_source=gthb&utm_medium=repo&utm_campaign=folding-cell">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
</p>
<p><h6>Stay tuned for the latest updates:</h6>
<a href="https://goo.gl/rPFpid" >
<img src="https://i.imgur.com/ziSqeSo.png/" width="156" height="28"></a></p>
<h6><a href="https://store.ramotion.com/product/iphone-x-clay-mockups?utm_source=gthb&utm_medium=special&utm_campaign=folding-cell#demo">Get Free Mockup For your project →</a></h6>

</br>

[![CocoaPods](https://img.shields.io/cocoapods/p/FoldingCell.svg)](https://cocoapods.org/pods/FoldingCell)
[![CocoaPods](https://img.shields.io/cocoapods/v/FoldingCell.svg)](http://cocoapods.org/pods/FoldingCell)
[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![Travis](https://img.shields.io/travis/Ramotion/folding-cell.svg)](https://travis-ci.org/Ramotion/folding-cell)
[![codebeat badge](https://codebeat.co/badges/6f67da5d-c416-4bac-9fb7-c2dc938feedc)](https://codebeat.co/projects/github-com-ramotion-folding-cell)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Accio supported](https://img.shields.io/badge/Accio-supported-0A7CF5.svg?style=flat)](https://github.com/JamitLabs/Accio)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-green.svg?style=flat)](https://developer.apple.com/swift/)
[![Analytics](https://ga-beacon.appspot.com/UA-84973210-1/ramotion/folding-cell)](https://github.com/igrigorik/ga-beacon)
[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/Ramotion)

## Requirements

- iOS 8.0+
- Xcode 10.2

## Installation

Just add the FoldingCell.swift file to your project.

or use [CocoaPods](https://cocoapods.org) with Podfile:
```
pod 'FoldingCell'
```
or [Carthage](https://github.com/Carthage/Carthage) users can simply add Mantle to their `Cartfile`:
```
github "Ramotion/folding-cell"
```
or use [Accio](https://github.com/JamitLabs/Accio) with Package.swift:
```swift
.package(url: "https://github.com/Ramotion/folding-cell.git", .upToNextMajor(from: "5.0.0")),
```

## Solution
![Solution](https://raw.githubusercontent.com/Ramotion/folding-cell/master/Tutorial-resources/Solution.png)
## Usage

1) Create a new cell inheriting from `FoldingCell`

2) Add a UIView to your cell in your storyboard or nib file, inheriting from `RotatedView`.
Connect the outlet from this view to the cell property `foregroundView`.
Add constraints from this view to the superview, as in this picture:

![1.1](https://raw.githubusercontent.com/Ramotion/folding-cell/master/Tutorial-resources/1.1.png)

(constants of constraints may be different). Connect the outlet from this top constraint to the cell property `foregroundViewTop`
. (This view will be shown when the cell is in its normal state).

3) Add other UIViews to your cell, connect the outlet from this view to the cell
property `containerView`. Add constraints from this view to the superview like in the picture:

![1.2](https://raw.githubusercontent.com/Ramotion/folding-cell/master/Tutorial-resources/1.2.png)

(constants of constraints may be different). Connect the outlet from this top constraint to the cell property `containerViewTop`.
(This view will be shown when the cell is opened)

Your result should be something like this picture:

![1.3](https://raw.githubusercontent.com/Ramotion/folding-cell/master/Tutorial-resources/1.3.png)


4) Set ``` @IBInspectable var itemCount: NSInteger ``` property is a count of folding (it IBInspectable you can set in storyboard). range 2 or greater. Default value is 2

Ok, we've finished configuring the cell.

5) Adding code to your UITableViewController

5.1) Add constants:
``` swift
fileprivate struct C {
  struct CellHeight {
    static let close: CGFloat = *** // equal or greater foregroundView height
    static let open: CGFloat = *** // equal or greater containerView height
  }
}
```
5.2) Add property for calculate cells height

``` swift
     var cellHeights = (0..<CELLCOUNT).map { _ in C.CellHeight.close }
```

5.3) Override method:
``` swift
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
```

5.4) Added code to method:
``` swift
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard case let cell as FoldingCell = tableView.cellForRowAtIndexPath(indexPath) else {
          return
        }

        var duration = 0.0
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }

        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { _ in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
```
5.5) Control if the cell is open or closed
``` swift
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if case let cell as FoldingCell = cell {
            if cellHeights![indexPath.row] == C.cellHeights.close {
                foldingCell.selectedAnimation(false, animated: false, completion:nil)
            } else {
                foldingCell.selectedAnimation(true, animated: false, completion: nil)
            }
        }
    }
```

6) Add this code to your new cell class
``` swift
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {

        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
```

## if don't use storyboard and xib files

Create foregroundView and containerView from code (steps 2 - 3) look example:
[Folding-cell-programmatically](https://github.com/ober01/Folding-cell-programmatically)

## 🗂 Check this library on other language:
<a href="https://github.com/Ramotion/folding-cell-android">
<img src="https://github.com/ramotion/navigation-stack/raw/master/Android_Java@2x.png" width="178" height="81"></a>


## 📄 License

Folding cell is released under the MIT license.
See [LICENSE](./LICENSE) for details.

This library is a part of a <a href="https://github.com/Ramotion/swift-ui-animation-components-and-libraries"><b>selection of our best UI open-source projects.</b></a>

If you use the open-source library in your project, please make sure to credit and backlink to www.ramotion.com

## 📱 Get the Showroom App for iOS to give it a try
Try this UI component and more like this in our iOS app. Contact us if interested.

<a href="https://itunes.apple.com/app/apple-store/id1182360240?pt=550053&ct=folding-cell&mt=8" >
<img src="https://github.com/ramotion/gliding-collection/raw/master/app_store@2x.png" width="117" height="34"></a>

<a href="https://dev.ramotion.com?utm_source=gthb&utm_medium=repo&utm_campaign=folding-cell">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
