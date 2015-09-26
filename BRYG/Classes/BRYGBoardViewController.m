//
//  BRYGBoardViewController.m
//  BRYG
//
//  Created by Ahmed Omer on 16/06/2015.
//  Copyright (c) 2015 Ahmed Omer. All rights reserved.
//

#define GRID_SIZE 16

#define Color(r,g,b)    [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define COLOR_BLUE      Color(41, 128, 185)
#define COLOR_RED       Color(231, 76, 60)
#define COLOR_YELLOW    Color(241, 196, 15)
#define COLOR_GREEN     Color(39, 174, 96)

#import <GameKit/GameKit.h>
#import <iAd/iAd.h>

#import "BRYGBoardViewController.h"
#import "BRYGNotificationViewController.h"
#import "BRYGUtilities.h"
#import "UIImageEffects.h"

@interface BRYGBoardViewController () <ADBannerViewDelegate, GKGameCenterControllerDelegate>
{
    BOOL            _gameCenterEnabled;
    
    int             _blockSize, _margin, _moves;
    
    ADBannerView    *_bannerView;
    NSDictionary    *_voidCoordinates;
    NSMutableArray  *_blocks, *_colors;
    NSString        *_leaderboardId;
}

@end

@implementation BRYGBoardViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initColors];
        
        [self initBlocks];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self authenticateLocalPlayer];
    
    [self layoutBlocks];
    
    [self initBannerView];
}

#pragma mark -

-(void)authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController,
                                        NSError *error) {
        
        if (viewController)
        {
            [self presentViewController:viewController
                               animated:YES
                             completion:nil];
            
            return;
        }
        
        if ([GKLocalPlayer localPlayer].authenticated)
        {
            _gameCenterEnabled = YES;
            
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier,
                                                                                                 NSError *error) {
                
                if (error)
                {
                    NSLog(@"%@", error.localizedDescription);
                }
                
                else
                {
                    _leaderboardId = leaderboardIdentifier;
                }
                
            }];
        }
        
        else
        {
            _gameCenterEnabled = NO;
        }
    };
}

- (UIView*)blockWithColor:(UIColor*)color
{
    UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, _blockSize, _blockSize)];
    
    imageView.backgroundColor = color;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 0.5;
    
    if ([color isEqual:COLOR_BLUE])
    {
        imageView.tag = 1;
    }
    
    else if ([color isEqual:COLOR_RED])
    {
        imageView.tag = 2;
    }
    
    else if ([color isEqual:COLOR_YELLOW])
    {
        imageView.tag = 3;
    }
    
    else if ([color isEqual:COLOR_GREEN])
    {
        imageView.tag = 4;
    }
    
    return imageView;
}

- (BOOL)didCompletePuzzle
{
    int halfSize = GRID_SIZE / 2;
    
    for (int outerIndex = 0; outerIndex < GRID_SIZE; outerIndex++)
    {
        for (int innerIndex = 0; innerIndex < GRID_SIZE; innerIndex++)
        {
            UIView *block = _blocks[outerIndex][innerIndex];
            
            if ((NSNull*)block == [NSNull null])
            {
                continue;
            }
            
            NSUInteger tag = block.tag;
            
            // BLUE
            
            if (outerIndex < halfSize &&
                innerIndex < halfSize)
            {
                if (tag != 1)
                {
                    return NO;
                }
            }
            
            // RED
            
            else if (outerIndex >= halfSize &&
                     innerIndex < halfSize)
            {
                if (tag != 2)
                {
                    return NO;
                }
            }
            
            // YELLOW
            
            else if (outerIndex < halfSize &&
                     innerIndex >= halfSize)
            {
                if (tag != 3)
                {
                    return NO;
                }
            }
            
            // GREEN
            
            else if (outerIndex >= halfSize &&
                     innerIndex >= halfSize)
            {
                if (tag != 4)
                {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

- (void)initBannerView
{
    if (_bannerView == nil)
    {
        _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        _bannerView.delegate = self;
    }
    
    [self layoutBannerView];
    
    if (_bannerView.superview == nil)
    {
        [self.view addSubview:_bannerView];
    }
}

- (void)initBlocks
{
    if (_blocks == nil)
    {
        _blocks = [NSMutableArray new];
    }
    
    else
    {
        [_blocks removeAllObjects];
    }
    
    for (int outerIndex = 0; outerIndex < GRID_SIZE; outerIndex++)
    {
        NSMutableArray *column = [NSMutableArray new];
        
        for (int innerIndex = 0; innerIndex < GRID_SIZE; innerIndex++)
        {
            [column addObject:[self blockWithColor:[self randomColor]]];
        }
        
        [_blocks addObject:column];
    }
    
    _blocks[GRID_SIZE - 1][GRID_SIZE - 1] = [NSNull null];
    _voidCoordinates = @{@"x":@(GRID_SIZE - 1),
                        @"y":@(GRID_SIZE - 1)};
}

- (void)initColors
{
    if (_colors == nil)
    {
        _colors = [NSMutableArray new];
    }
    
    else
    {
        [_colors removeAllObjects];
    }
    
    int colorCount = (GRID_SIZE/2) * (GRID_SIZE/2);
    
    for (int indexBlue = 0; indexBlue < colorCount; indexBlue++)
    {
        [_colors addObject:COLOR_BLUE];
    }
    
    for (int indexRed = 0; indexRed < colorCount; indexRed++)
    {
        [_colors addObject:COLOR_RED];
    }
    
    for (int indexYellow = 0; indexYellow < colorCount; indexYellow++)
    {
        [_colors addObject:COLOR_YELLOW];
    }
    
    for (int indexGreen = 0; indexGreen < colorCount; indexGreen++)
    {
        [_colors addObject:COLOR_GREEN];
    }
}

- (void)layoutBlocks
{
    _blockSize = (self.view.frame.size.width - 40.0) / GRID_SIZE;
    _margin = ((self.view.frame.size.width - 40.0) - (_blockSize * GRID_SIZE)) / 2.0;
    
    self.blueConstraint.constant = 20 + _margin;
    self.redConstraint.constant = 20 + _margin;
    self.yellowConstraint.constant = 20 + _margin;
    self.greenConstraint.constant = 20 + _margin;
    
    for (int outerIndex = 0; outerIndex < GRID_SIZE; outerIndex++)
    {
        for (int innerIndex = 0; innerIndex < GRID_SIZE; innerIndex++)
        {
            UIView *block = _blocks[outerIndex][innerIndex];
            
            if ((NSNull*)block != [NSNull null])
            {
                block.frame = CGRectMake(_margin + (_blockSize * outerIndex), _margin + (_blockSize * innerIndex), _blockSize, _blockSize);
                
                [self.canvasView addSubview:block];
            }
        }
    }
    
    self.lblBlue.hidden = NO;
    self.lblGreen.hidden = NO;
    self.lblRed.hidden = NO;
    self.lblYellow.hidden = NO;
    self.lblMoves.hidden = NO;
}

- (UIColor*)randomColor
{
    int colorIndex = arc4random()%(_colors.count);
    
    UIColor *color = _colors[colorIndex];
    
    [_colors removeObjectAtIndex:colorIndex];
    
    return color;
}

- (void)reportScore
{
    if (_gameCenterEnabled == NO ||
        _leaderboardId == nil)
    {
        return;
    }
    
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardId];
    score.value = _moves;
    
    [GKScore reportScores:@[score]
    withCompletionHandler:^(NSError *error)
     {
         if (error)
         {
             NSLog(@"%@", error.localizedDescription);
         }
     }];
}

- (void)showNotificationScreen
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        
        [self performSegueWithIdentifier:@"SegueGameComplete"
                                  sender:nil];
    });
}


#pragma mark - IBAction

- (IBAction)didSwipe:(UISwipeGestureRecognizer*)sender
{
    UISwipeGestureRecognizerDirection direction = sender.direction;
    UIView *blockToMove = nil;
    
    int x = [_voidCoordinates[@"x"] intValue], y = [_voidCoordinates[@"y"] intValue];
    int dx = 0, dy = 0, dw = 0, dh = 0;
    
    switch (direction)
    {
        case UISwipeGestureRecognizerDirectionUp:
        {
            if (y < (GRID_SIZE - 1))
            {
                dx = 0, dy = 1, dw = 0; dh = -(_blockSize);
            }
            
            break;
        }
            
        case UISwipeGestureRecognizerDirectionDown:
        {
            if (y > 0)
            {
                dx = 0, dy = -1, dw = 0; dh = _blockSize;
            }
            
            break;
        }
            
        case UISwipeGestureRecognizerDirectionLeft:
        {
            if (x < GRID_SIZE - 1)
            {
                dx = 1, dy = 0, dw = -(_blockSize); dh = 0;
            }
            
            break;
        }
            
        case UISwipeGestureRecognizerDirectionRight:
        {
            if (x > 0)
            {
                dx = -1, dy = 0, dw = _blockSize; dh = 0;
            }
            
            break;
        }
            
        default:
            break;
    }
    
    if (dx == 0 && dy == 0)
    {
        return;
    }
    
    blockToMove = _blocks[x + dx][y + dy];
    _voidCoordinates = @{@"x":@(x + dx),
                        @"y":@(y + dy)};
    
    _blocks[x][y] = blockToMove;
    _blocks[x + dx][y + dy] = [NSNull null];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    
    CGRect frame = blockToMove.frame;
    frame.origin.x += dw;
    frame.origin.y += dh;
    
    blockToMove.frame = frame;
    
    [UIView commitAnimations];
    
    _moves++;
    
    self.lblMoves.text = [BRYGUtilities stringForMoves:_moves];
    
    if ([self didCompletePuzzle])
    {
        [self showNotificationScreen];
        [self reportScore];
    }
}

- (IBAction)reloadBoard
{
    [self initColors];
    
    [self initBlocks];
    
    for (UIView* view in self.canvasView.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self layoutBlocks];
    
    _moves = 0;
    
    self.lblMoves.text = [NSString stringWithFormat:@"%d MOVES", _moves];
}

- (IBAction)showLeaderboard
{
    if (_gameCenterEnabled == NO ||
        _leaderboardId == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Center Unavailable"
                                                        message:@"Please sign in to Game Center to view the leaderboard."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        
        [alert show];
        
        return;
    }
    
    GKGameCenterViewController *controller = [[GKGameCenterViewController alloc] init];
    
    controller.gameCenterDelegate = self;
    controller.viewState = GKGameCenterViewControllerStateLeaderboards;
    controller.leaderboardIdentifier = _leaderboardId;
    
    [self presentViewController:controller
                       animated:YES
                     completion:nil];
}

#pragma mark - GKGameCenterControllerDelegate

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES
                                                 completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BRYGNotificationViewController *controller = segue.destinationViewController;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(cgcontext, 0, 0);
    
    [self.view.layer renderInContext:cgcontext];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [UIImageEffects imageByApplyingExtraLightEffectToImage:image];
    
    controller.numberOfMoves = _moves;
    controller.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       
                       [self reloadBoard];
                   });
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutBannerView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutBannerView];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)layoutBannerView
{
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = _bannerView.frame;
    
    if (_bannerView.bannerLoaded)
    {
        contentFrame.size.height -= _bannerView.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    else
    {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _bannerView.frame = bannerFrame;
    }];
}

@end
