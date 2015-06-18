//
//  GameCompleteViewController.h
//  BRYG
//
//  Created by Ahmed Omer on 18/06/2015.
//  Copyright (c) 2015 Ahmed Omer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRYGNotificationViewController : UIViewController

@property (nonatomic, assign) int numberOfMoves;
@property (nonatomic, weak) IBOutlet UILabel *message;

@end
