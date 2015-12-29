# FoldingCell

[shot on dribbble](https://dribbble.com/shots/2121350-Delivery-Card):
![Animation](Screenshots/folding-cell.gif)

## Requirements

- iOS 8.0+
- Xcode 7.2

## Installation

Just add the FoldingCell.swift file to your project.

or use [CocoaPods](https://cocoapods.org) with Podfile:
``` ruby
pod 'FoldingCell', '~> 0.1'
```
    

## Solution
![Solution](/Tutorial-resources/Solution.png)
## Usage

1) Create a new cell inheriting from `FoldingCell`

2) Add a UIView to your cell in your storyboard or nib file, inheriting from `RotatedView`.
Connect the outlet from this view to the cell property `foregroundView`.
Add constraints from this view to the superview, as in this picture: 
![1.1](/Tutorial-resources/1.1.png)

(constants of constraints may be different). Add the identifier `ForegroundViewTop`
for the top constraint. (This view will be shown when the cell is in its normal state).

3) Add other UIViews to your cell, connect the outlet from this view to the cell
property `containerView`. Add constraints from this view to the superview like in the picture:

![1.2](/Tutorial-resources/1.2.png)

(constants of constraints may be different). Add the identifier "ContainerViewTop" for the top constraint.
(This view will be shown when the cell is opened)

Your result should be something like this picture:
![1.3](/Tutorial-resources/1.3.png)

4) Now lets add folding views

4.1) Add a UIView to `containerView` (where `ContainerView` is the UIView which you've added on step 3)
Add constraints from this view to `containerView` as in the picture:

![1.4](/Tutorial-resources/1.4.png)

For correct animation, the height constraint constant should be equal to `foregroundView`'s height constraint constant.
Result: 

![1.5](/Tutorial-resources/1.5.png)

4.2) Add a `UIView` to `containerView` inheriting from `RotatedView`. Add constraints from
this view to `containerView` as in the picture:

![1.6](/Tutorial-resources/1.6.png).

For correct animation, the height constraint constant must be equal to `foregroundView`'s height constraint constant.
Add the identifier "yPosition" for the top constraint. **The tag must be equal to 1**
Result: 

![1.7](/Tutorial-resources/1.7.png)

The following steps are optional (you can add as many views as you want).

4.3) repeat 4.2, but **increasing the tag by one**. (For the correct animation, height of the view
must be less than or equal to that of the previous view).

The height of `containerView` must be equal to the sum of the heights of its subviews:
![1.8](/Tutorial-resources/1.8.png)

Ok, we've finished configuring the cell.

5) Adding code to your UITableViewController

5.1) Add constants:
``` swift
     let kCloseCellHeight: CGFloat = *** // equal or greater foregroundView height
     let kOpenCellHeight: CGFloat = *** // equal or greater containerView height
```
5.2) Add property

``` swift
     var cellHeights: [CGFloat]?
```

     create in viewDidLoad:
``` swift
     override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0...kRowsCount {
            cellHeights?.append(kCloseCellHeight)
        }
    }
```

5.3) Override method:
``` swift
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights![indexPath.row]
    }
```

5.4) Added code to method:
``` swift
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell

        var duration = 0.0
        if cellHeights![indexPath.row] == kCloseCellHeight { // open cell
            cellHeights![indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights![indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        }

        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
```
5.5) Control if the cell is open or closed
``` swift
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if cell is FoldingCell {
            let foldingCell = cell as! FoldingCell

            if cellHeights![indexPath.row] == kCloseCellHeight {
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

        // durations count equal containerView.subViews.count - 1
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
```

## [About Us](http://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=folding-cell)

[Ramotion - digital product design agency](http://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=folding-cell)  
We are ready for new interesting iOS app development projects.

Follow us on [Twitter](http://twitter.com/ramotion).
