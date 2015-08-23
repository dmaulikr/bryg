//
//  GameCompleteViewController.m
//  BRYG
//
//  Created by Ahmed Omer on 18/06/2015.
//  Copyright (c) 2015 Ahmed Omer. All rights reserved.
//

#import "BRYGNotificationViewController.h"
#import "BRYGUtilities.h"

@implementation BRYGNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *moves = [BRYGUtilities stringForMoves:self.numberOfMoves];
    
    NSString *textToDisplay = [NSString stringWithFormat:@"%@\n\nHead over to the leaderboard and see how you compare to other players. Keep your moves to a minimum to make your way up the leaderboard.", moves];
    
    UIFont *font = self.message.font;
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:textToDisplay
                                                                               attributes:@{NSFontAttributeName: font}];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont boldSystemFontOfSize:15.0]
                   range:[textToDisplay rangeOfString:[NSString stringWithFormat:@"%@", moves]]];

    self.message.attributedText = string;
}

- (IBAction)dismiss
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
