//
//  MainViewController.h
//  project2
//
//  Created by johan on 10/5/13.
//  Copyright (c) 2013 Johan Boon. All rights reserved.
//

#import "FlipsideViewController.h"
#import "HistoryViewController.h"


@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, HistoryViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *wordLabel;
@property (nonatomic, strong) IBOutlet UILabel *guessesLabel;
@property (nonatomic, strong) IBOutlet UILabel *alphabetLabel;
@property (nonatomic, strong) IBOutlet UITextField *inputTextField;
@property (nonatomic, strong) IBOutlet UIProgressView *guessesBar;

@property (assign, nonatomic) int wordLength;
@property (assign, nonatomic) bool evilGameplay;
@property (assign, nonatomic) bool currentEvilGameplay;
@property (nonatomic, strong) NSString *currentWord;
@property (assign, nonatomic) int currentGuesses;
@property (assign, nonatomic) int totalGuesses;
@property (assign, nonatomic) bool gameNotFinished;
@property (nonatomic, strong) NSString *currentAlphabet;
@property (assign, nonatomic) float guessesBarDegradation;
@property (assign, nonatomic) float guessesBarProgress;
@property (nonatomic, strong) NSArray *pickedWord;

- (IBAction)showOptions:(id)sender;
- (IBAction)showHistory:(id)sender;
- (IBAction)startGame:(id)sender;
- (IBAction)readCharFromKeyboard:(id)sender;

@end
