//
//  TableViewController.m
//  folding-cell-test
//
//  Created by Abdurahim Jauzee on 30/05/2017.
//  Copyright © 2017 Abdurahim Jauzee. All rights reserved.
//

#import "TableViewController.h"
#import <FoldingCell/FoldingCell-Swift.h>

@interface TableViewController ()

@property (atomic) float kCloseCellHeight;
@property (atomic) float kOpenCellHeight;
@property (atomic) int kRowsCount;
@property (atomic) NSMutableArray* cellHeights;

@end

@implementation TableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.kCloseCellHeight = 179;
  self.kOpenCellHeight = 488;
  self.kRowsCount = 10;
  self.cellHeights = [NSMutableArray array];
  
  for (int i = 0; i < 10; i++) {
    [self.cellHeights addObject:[NSNumber numberWithFloat:self.kCloseCellHeight]];
  }
  
  self.tableView.estimatedRowHeight = self.kCloseCellHeight;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  
  UIImage *patternImage = [UIImage imageNamed:@"background"];
  UIColor *patternColor = [UIColor colorWithPatternImage:patternImage];
  self.tableView.backgroundColor = patternColor;
  
  self.tableView.contentInset = UIEdgeInsetsMake(16, 0, 0, 0);
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.kRowsCount;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  cell.backgroundColor = [UIColor clearColor];
  NSNumber *height = [self.cellHeights objectAtIndex:indexPath.row];
  bool cellIsCollapsed = height.floatValue == self.kCloseCellHeight;
  if (cellIsCollapsed) {
    [(FoldingCell *) cell selectedAnimation:false animated:false completion: nil];
  } else {
    [(FoldingCell *) cell selectedAnimation:true animated:false completion: nil];
  }
  
  UIView *backgroundTopView = [cell viewWithTag:11];
  CALayer *backgroundTopViewLayer = backgroundTopView.layer;
  backgroundTopViewLayer.cornerRadius = 10;
  backgroundTopViewLayer.masksToBounds = YES;
  
  UILabel *closeNumberlabel = [cell viewWithTag:12];
  UILabel *openNumberLabel = [cell viewWithTag:13];
  
  NSString *text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
  closeNumberlabel.text = text;
  openNumberLabel.text = text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FoldingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoldingCell"];
  cell.backgroundColor = [UIColor clearColor];
  CALayer *layer = ((FoldingCell *) cell).foregroundView.layer;
  layer.cornerRadius = 10;
  layer.masksToBounds = YES;
  
  NSArray *durations = @[@0.26, @0.2, @0.2];
  [cell setDurationsForExpandedState:durations];
  [cell setDurationsForCollapsedState:durations];
  
  return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *height = self.cellHeights[indexPath.row];
  return height.floatValue;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  FoldingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
  if (cell.isAnimating) {
    return;
  }
  
  double duration = 0;
  NSNumber *height = [self.cellHeights objectAtIndex:indexPath.row];
  bool cellIsCollapsed = height.floatValue == self.kCloseCellHeight;
  if (cellIsCollapsed) {
    [self.cellHeights setObject:[NSNumber numberWithFloat:self.kOpenCellHeight] atIndexedSubscript:indexPath.row];
    [cell selectedAnimation:true animated:true completion: nil];
    duration = 0.5;
  } else {
    [self.cellHeights setObject:[NSNumber numberWithFloat:self.kCloseCellHeight] atIndexedSubscript:indexPath.row];
    [cell selectedAnimation:false animated:true completion: nil];
    duration = 0.8;
  }
  
  [UIView animateWithDuration:duration delay:0 options:0 animations:^{
    [tableView beginUpdates];
    [tableView endUpdates];
  } completion:nil];

}

@end
