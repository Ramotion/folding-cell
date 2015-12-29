# FoldingCell

[shot on dribbble](https://dribbble.com/shots/2121350-Delivery-Card):
![Animation](Screenshots/folding-cell.gif)

## Requirements

- iOS 8.0+
- Xcode 7.2

## Installation

Just add the FoldingCell.swift file to your project.

## Usage

1) Create a new cell inherit from FoldingCell

2) Add UIView to your cell in your storyboard or nib file, inherit it from RotatedView.
Connect the outlet from this view to the cell property "foregroundView".
Add constraints from this view to superview like a picture: 
![1.1](/Tutorial-resources/1.1.png)

(constants of constraints may be differents). Add identifier "ForegroundViewTop"
for top constraint. (This view will be show than cell is normal state).

3) Add other UIView to your cell, connect the outlet from this view to the cell
property "containerView". Add constraints from this view to superview like a picture:

![1.2](/Tutorial-resources/1.2.png)

(constants of constraints may be differents). Add identifier "ContainerViewTop" for top constraint.
(This view will be show than cell is open state)

Your result something like this picture:
![1.3](/Tutorial-resources/1.3.png)

4) Now lets add folding views

4.1) Add UIView to containerView (ContanerView is a UIView which your add on step 3)
Add constraints from this view to containerView like a picture:

![1.4](/Tutorial-resources/1.4.png)

For correct animation height constraint constant may be equal foregroundView height constraint constant.
Result: 
![1.5](/Tutorial-resources/1.5.png)

4.2) Add UIView to containerView inherit it from RotatedView. Add constraints from
this view to containerView like a picture:

![1.6](/Tutorial-resources/1.6.png).

For correct animation height constraint constant may be equal foregroundView height constraint constant.
Add identifier "yPosition" for top constraint. tag must be equal 1
Result: 

![1.7](/Tutorial-resources/1.7.png)

Next steps is optional (You can add views how many do you want)

4.3) repeat 4.2 step only increase tag for one. (For correct animation height of the view
must be lower or equal previous view)

Height of contanerView must be equal sum of heights its subviews picture:
![1.8](/Tutorial-resources/1.8.png)

ok we finish configure cell
