//
//  ViewController.h
//  BRYG
//
//  Created by Ahmed Omer on 16/06/2015.
//  Copyright (c) 2015 Ahmed Omer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *lblMoves;
@property (nonatomic, weak) IBOutlet UIView *canvasView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *blueConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *redConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *yellowConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *greenConstraint;

@end

