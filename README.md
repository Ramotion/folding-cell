[![header](https://raw.githubusercontent.com/Ramotion/folding-cell/master/header.png)](https://business.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=foolding-cell-logo)
# FoldingCell
[![CocoaPods](https://img.shields.io/cocoapods/p/FoldingCell.svg)](https://cocoapods.org/pods/FoldingCell)
[![CocoaPods](https://img.shields.io/cocoapods/v/FoldingCell.svg)](http://cocoapods.org/pods/FoldingCell)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/FoldingCell.svg)](https://cdn.rawgit.com/Ramotion/folding-cell/master/docs/index.html)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Ramotion/folding-cell)
[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![Travis](https://img.shields.io/travis/Ramotion/folding-cell.svg)](https://travis-ci.org/Ramotion/folding-cell)
[![codebeat badge](https://codebeat.co/badges/6f67da5d-c416-4bac-9fb7-c2dc938feedc)](https://codebeat.co/projects/github-com-ramotion-folding-cell)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Analytics](https://ga-beacon.appspot.com/UA-84973210-1/ramotion/folding-cell)](https://github.com/igrigorik/ga-beacon)

## About
This project is maintained by Ramotion, Inc.<br>
We specialize in the designing and coding of custom UI for Mobile Apps and Websites.<br><br>**Looking for developers for your project?** [[▶︎CONTACT OUR TEAM◀︎](http://business.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=foolding-cell-contact-us/#Get_in_Touch)]

[![Animation](https://raw.githubusercontent.com/Ramotion/folding-cell/master/Screenshots/folding-cell.gif)](https://dribbble.com/shots/2121350-Delivery-Card)


The [iPhone mockup](https://store.ramotion.com/product/iphone-6-mockups?utm_source=gthb&utm_medium=special&utm_campaign=folding-cell) available [here](https://store.ramotion.com/product/iphone-6-mockups?utm_source=gthb&utm_medium=special&utm_campaign=folding-cell).
## Requirements

- iOS 8.0+
- Xcode 7.3

## Installation

Just add the FoldingCell.swift file to your project.

or use [CocoaPods](https://cocoapods.org) with Podfile:
pod 'FoldingCell' '~> 2.0.2' 

or [Carthage](https://github.com/Carthage/Carthage) users can simply add Mantle to their `Cartfile`:
```
github "Ramotion/folding-cell"

```

or just drag and drop FoldingCell.swift file to your project

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

[Demonstration adding constraints for foregroundView, containerView](https://vimeo.com/154954299)

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
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
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


#### if don't use storyboard and xib files

Create foregroundView and containerView from code (steps 2 - 3) look example:
[Folding-cell-programmatically](https://github.com/ober01/Folding-cell-programmatically)

## Licence

Folding cell is released under the MIT license.
See [LICENSE](./LICENSE) for details.


## Follow Us

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/ramotion/foolding-cell)
[![Twitter Follow](https://img.shields.io/twitter/follow/ramotion.svg?style=social)](https://twitter.com/ramotion)
