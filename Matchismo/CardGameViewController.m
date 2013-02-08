//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Alex Paul on 1/25/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "GameResults.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipsCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame *game; 
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cardMatchingModeSwitch;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (nonatomic) int cardMatchMode;

//  Game Results
@property (nonatomic, strong) GameResults *gameResult; 

//  Keeps track of the flips history
@property (nonatomic, strong) NSMutableArray *flipsHistoryArray;
@end

@implementation CardGameViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.cardMatchingModeSwitch.on = NO;
    
    self.historySlider.minimumValue = 0;
    self.historySlider.continuous = YES; 
    
    self.flipsHistoryArray = [[NSMutableArray alloc] init];
}

- (GameResults *)gameResult
{
    if (!_gameResult) {
        _gameResult = [[GameResults alloc] init];
    }
    return _gameResult; 
}

- (CardMatchingGame *)game
{
    self.cardMatchMode = (self.cardMatchingModeSwitch.on) ? 3 : 2;
    
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init] cardMatchMode:self.cardMatchMode];
    }
    return _game; 
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha =  card.isUnplayable ? 0.3 : 1.0;
                
        //  Toggle card background image
        if (cardButton.selected) {
            [cardButton setBackgroundImage:[UIImage imageNamed:@"whiteBackground.png"] forState:UIControlStateNormal];
        }else {
            [cardButton setBackgroundImage:[UIImage imageNamed:@"cardBack.png"] forState:UIControlStateNormal];
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultsLabel.textColor = [UIColor blackColor];
    self.resultsLabel.text = self.game.resultsString;
    
    if (self.game.resultsString != nil) {
        //  Save results match to flipsArray
        [self.flipsHistoryArray addObject:self.game.resultsString];
    }
    
    //  Set maximum value of slider
    self.historySlider.maximumValue = [self.flipsHistoryArray count];
}

- (void)setFlipsCount:(int)flipsCount
{
    _flipsCount = flipsCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipsCount];
    
    //  Update the Game Result
    self.gameResult.score = self.game.score; 
}

- (IBAction)flipCard:(UIButton *)sender
{
    self.cardMatchingModeSwitch.enabled = NO;
    
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];

    self.flipsCount++;
    
    [self updateUI];
}

- (IBAction)dealNewDeck:(UIButton *)sender
{
    self.cardMatchingModeSwitch.enabled = YES;
        
    NSLog(@"card match mode is %d", self.cardMatchMode);
    
    //self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init] cardMatchMode:self.cardMatchMode];
    
    self.game = nil;
    
    self.gameResult = nil; 
    
    [self updateUI];
    
    self.flipsCount = 0;
    
    self.resultsLabel.textColor = [UIColor blackColor];
    
    self.resultsLabel.text = @"New Game";

}

- (IBAction)cardMatchingMode:(UISwitch *)sender
{
    self.cardMatchMode = (sender.on) ? 3 : 2;
    
    [self dealNewDeck:nil]; 
    
    NSLog(@"card match mode is %d", self.cardMatchMode);

}

- (IBAction)showFlipHistory:(UISlider *)sender
{
    NSLog(@"slider maximum value is %f", self.historySlider.maximumValue);
    
    NSLog(@"slider value is %f", sender.value);
    
    //int maxLength = (int)sender.maximumValue;
    
    if ([self.flipsHistoryArray count] != 0 && (sender.value != sender.maximumValue)) {
        self.resultsLabel.textColor = [UIColor lightGrayColor];
        self.resultsLabel.text = self.flipsHistoryArray[(int)sender.value];
    }
}

@end
