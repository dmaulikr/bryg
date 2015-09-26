//
//  BRYGUtilities.m
//  BRYG
//
//  Created by Ahmed Omer on 18/06/2015.
//  Copyright (c) 2015 Ahmed Omer. All rights reserved.
//

#import "BRYGUtilities.h"

@implementation BRYGUtilities

+ (NSString*)stringForMoves:(int)moves
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [NSString stringWithFormat:@"%@ MOVES", [formatter stringFromNumber:@(moves)]];
}

@end
