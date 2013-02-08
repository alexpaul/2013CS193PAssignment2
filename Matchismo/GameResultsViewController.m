//
//  GameResultsViewController.m
//  Matchismo
//
//  Created by Alex Paul on 2/8/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "GameResultsViewController.h"
#import "GameResults.h"

@interface GameResultsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;

@end

@implementation GameResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup]; 
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup]; 
}

- (void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:YES];
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    NSString *displayText = @"";
    for (GameResults *result in [GameResults allGameResults]) {
        displayText = [displayText stringByAppendingFormat:@"Score: %d, (%@, %0g) \n", result.score, result.end, round(result.duration)];
    }
    self.display.text = displayText; 
}

- (void)setup
{
    // Initialization that can't wait until viewDidLoad
}

@end
