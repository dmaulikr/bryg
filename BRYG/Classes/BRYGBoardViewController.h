//
//  BRYGBoardViewController.h
//  BRYG
//
//  Created by Ahmed Omer on 16/06/2015.
//  Copyright (c) 2015 Ahmed Omer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRYGBoardViewController : UIViewController

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *blueConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *redConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *yellowConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *greenConstraint;

@property (nonatomic, weak) IBOutlet UILabel *lblMoves;
@property (nonatomic, weak) IBOutlet UILabel *lblBlue;
@property (nonatomic, weak) IBOutlet UILabel *lblRed;
@property (nonatomic, weak) IBOutlet UILabel *lblYellow;
@property (nonatomic, weak) IBOutlet UILabel *lblGreen;

@property (nonatomic, weak) IBOutlet UIView *canvasView;

@end

