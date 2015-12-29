# FoldingCell

[shot on dribbble](https://dribbble.com/shots/2121350-Delivery-Card):
![Animation](Screenshots/folding-cell.gif)

## Requirements

- iOS 8.0+
- Xcode 7.2

## Installation

Just add the FoldingCell.swift file to your project.

## Usage

1. Create a new cell inherit from FoldingCell

2. Add UIView to your cell in your storyboard or nib file, inherit it from RotatedView.
Connect the outlet from this view to the cell property "foregroundView".
Add constraints from this view to superview like a picture: 
![1.1](/Tutorial-resources/1.1.png)

(constants of constraints may be differents). Add identifier "ForegroundViewTop"
for top constraint. (This view will be show than cell is normal state) 
