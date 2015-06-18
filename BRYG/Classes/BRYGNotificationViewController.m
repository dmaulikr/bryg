//
//  GameCompleteViewController.m
//  BRYG
//
//  Created by Ahmed Omer on 18/06/2015.
//  Copyright (c) 2015 Ahmed Omer. All rights reserved.
//

#import "BRYGNotificationViewController.h"

#import <Appirater/Appirater.h>

@implementation BRYGNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *moves = [self stringForMoves];
    
    NSString *textToDisplay = [NSString stringWithFormat:@"%@ MOVES\n\nHead over to the leaderboard and see how you compare to other players. Keep your moves to a minimum to make your way up the leaderboard.", moves];
    
    UIFont *font = self.message.font;
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:textToDisplay
                                                                               attributes:@{NSFontAttributeName: font}];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]
                   range:[textToDisplay rangeOfString:[NSString stringWithFormat:@"%@ MOVES", moves]]];

    self.message.attributedText = string;
}

- (NSString*)stringForMoves
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [formatter stringFromNumber:@(self.numberOfMoves)];
}

- (IBAction)dismiss
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
                                 [Appirater userDidSignificantEvent:YES];
                             }];
}

@end