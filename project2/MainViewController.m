//
//  MainViewController.m
//  project2
//
//  Created by johan on 10/5/13.
//  Copyright (c) 2013 Johan Boon. All rights reserved.
//

#import "MainViewController.h"
#import "EvilGameplay.h"
#import "GoodGameplay.h"
#import "History.h"
#import "GameplayDelegate.h"
#include <ctype.h>

@interface MainViewController ()
// private
- (void) loadGameSettings;
- (void) saveGameSettings;
- (void) gameWon;
- (void) gameLost;
- (void) finishGame;
- (NSString *) setupWordDashes: (int) wordDashes;
@end

@implementation MainViewController

id <GameplayDelegate> gameplay;

@synthesize wordLength = _wordLength;
@synthesize currentWord = _currentWord;
@synthesize currentGuesses = _currentGuesses;
@synthesize totalGuesses = _totalGuesses;
@synthesize guessesBarDegradation = _guessesBarDegradation;
@synthesize guessesBarProgress = _guessesBarProgress;
@synthesize gameNotFinished = _gameNotFinished;
@synthesize currentAlphabet = _currentAlphabet;
@synthesize currentEvilGameplay = _currentEvilGameplay;
@synthesize pickedWord = _pickedWord;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set default values to local storage
    NSMutableDictionary *defaultValues = [[NSMutableDictionary alloc] init];
    [defaultValues setObject:@"5" forKey:@"wordLength"];
    [defaultValues setObject:@"8" forKey:@"guesses"];
    [defaultValues setObject:@"true" forKey:@"evilPlay"];
    [defaultValues setObject:@"true" forKey:@"currentEvilPlay"];
    [defaultValues setObject:@"-1" forKey:@"currentWord"];
    [defaultValues setObject:@"1.0" forKey:@"barProgress"];
    [defaultValues setObject:@"-1" forKey:@"barDegradation"];
    [defaultValues setObject:@"false" forKey:@"gameNotFinished"];
    [defaultValues setObject:@"-1" forKey:@"currentGuesses"];
    [defaultValues setObject:[NSArray arrayWithObject:@"dummy"] forKey:@"pickedWord"];
    [defaultValues setObject:@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
                      forKey:@"currentAlphabet"];
    
    // register default values to local storage
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:defaultValues];
    
    // start game
    [self startGame:(nil)];
}


- (IBAction)startGame:(id)sender {
    
    if (sender != nil) {
        [self finishGame];
    }
    
    // load game settings
    [self loadGameSettings];
    

    
    // show keyboard
    [self.inputTextField becomeFirstResponder];
}


- (void) loadGameSettings {
    
    // load from local storage
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.wordLength = [[defaults stringForKey:@"wordLength"]intValue];
    self.totalGuesses = [[defaults stringForKey:@"guesses"]intValue];
    self.evilGameplay = [[defaults stringForKey:@"evilPlay"]intValue];
    self.currentEvilGameplay = [[defaults stringForKey:@"currentEvilPlay"]intValue];
    self.guessesBarProgress = [[defaults stringForKey:@"barProgress"]floatValue];
    self.guessesBarDegradation = [[defaults stringForKey:@"barDegradation"]floatValue];
    self.gameNotFinished = [[defaults stringForKey:@"gameNotFinished"]intValue];
    self.currentAlphabet = [defaults stringForKey:@"currentAlphabet"];
    self.currentWord = [defaults stringForKey:@"currentWord"];
    self.currentGuesses = [[defaults stringForKey:@"currentGuesses"]intValue];
    self.pickedWord = [NSArray arrayWithArray:[defaults objectForKey:@"pickedWord"]];
    
    // settings for a new game
    if (!self.gameNotFinished) {
        // restore alphabet
        self.currentAlphabet = @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";

        // fill the guessesBar
        self.guessesBarProgress = 1;
        
        // calculate guessesBarDegradation
        // the extra 0.000001 is to make the bar completely empty after the last wrong guess
        self.guessesBarDegradation = 1.0 / self.totalGuesses + 0.000001;
        
        // setup initial word - example: _ _ _ _ _
        self.currentWord = [self setupWordDashes:self.wordLength];
        
        // setup current guesses
        self.currentGuesses = self.totalGuesses;
        
        // setup gameplay
        self.currentEvilGameplay = self.evilGameplay;
    }
    
    // set values to view objects
    self.alphabetLabel.text = self.currentAlphabet;
    self.guessesBar.progress = self.guessesBarProgress;
    self.wordLabel.text = self.currentWord;
    self.guessesLabel.text = [NSString stringWithFormat:@"%i", self.currentGuesses];
    
    // create a gameplay object
    if (self.currentEvilGameplay) {
        gameplay = [[EvilGameplay alloc] init];
    } else {
        gameplay = [[GoodGameplay alloc] init];
    }
    
    // load new word or load old one
    if (!self.gameNotFinished) {
        // pick a word for new game
        [gameplay selectAWordWithSize:self.wordLength];
    } else {
        // load array
        [gameplay loadArrayWithWords:self.pickedWord];
    }
}


- (void) saveGameSettings {
    self.currentAlphabet = self.alphabetLabel.text;
    self.guessesBarProgress = self.guessesBar.progress;
    self.currentWord = self.wordLabel.text;
    self.currentGuesses = [self.guessesLabel.text intValue];
    self.pickedWord = [gameplay getSelectedWord];
    
    // save to local storage
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.currentEvilGameplay forKey:@"currentEvilPlay"];
    [defaults setFloat:self.guessesBarProgress forKey:@"barProgress"];
    [defaults setFloat:self.guessesBarDegradation forKey:@"barDegradation"];
    [defaults setBool:self.gameNotFinished forKey:@"gameNotFinished"];
    [defaults setObject:self.currentAlphabet forKey:@"currentAlphabet"];
    [defaults setInteger:self.currentGuesses forKey:@"currentGuesses"];
    [defaults setObject:self.currentWord forKey:@"currentWord"];
    [defaults setObject:self.pickedWord forKey:@"pickedWord"];
    [defaults synchronize];
}


- (IBAction)readCharFromKeyboard:(id)sender {
    
    char chosenChar;
    
    // get char from InputTextField
    chosenChar = [self.inputTextField.text characterAtIndex:0];
    chosenChar = toupper(chosenChar);
    
    //if char not A-Z then return
    if(!isalpha(chosenChar)) {
        self.inputTextField.text = @"";
        return;
    }
   
    NSMutableString *tempAlphabet;
    
    // copy alphabetLabel to tempAlphabet
    tempAlphabet = self.alphabetLabel.text.mutableCopy;
    
    // get index from chosenChar
    NSRange oneChar = [tempAlphabet rangeOfString:([NSString stringWithFormat:@"%c", chosenChar])];

    // if char already guessed then return
    if (oneChar.length == 0) {
        self.inputTextField.text = @"";
        return;
    }
   
    // remove char
    [tempAlphabet replaceCharactersInRange:(oneChar) withString:(@" ")];

    // write back to label
    self.alphabetLabel.text = tempAlphabet;
    
    // remove char from InputTextField
    self.inputTextField.text = @"";
    
    // game not finished
    self.gameNotFinished = true;
    
    // check if new char found in the word
    NSString *tempWord = [gameplay  lookupChars:chosenChar inWord:self.currentWord.mutableCopy];
    if (tempWord == nil) {
        self.currentGuesses -= 1;
        self.guessesLabel.text = [NSString stringWithFormat:@"%i", self.currentGuesses];
        self.guessesBar.progress -= self.guessesBarDegradation;
        //check if game is lost
        [self gameLost];
    } else {
        self.currentWord = tempWord;
        self.wordLabel.text = self.currentWord;
        //check if game is won
        [self gameWon];
    }
    
    // saveGameSettings
    [self saveGameSettings];
    
}


- (void) gameWon {

    // get index from '_'
    NSRange underscore = [self.currentWord rangeOfString:@"_"];
    
    // if no '_' then word is complete
    if (underscore.length == 0) {
        // hide keyboard
        [self.inputTextField resignFirstResponder];
        
        // game finished
        [self finishGame];
        
        // Save game stats to history
        [History storeHighScoreWord:[[gameplay getSelectedWord] objectAtIndex:0]
                        andMistakes:(self.totalGuesses-self.currentGuesses)];
        
        // show popup
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are awesome!!"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Thanks!"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (void) gameLost {
    // check if currentguesses is 0
    if (self.currentGuesses == 0) {
        // hide keyboard
        [self.inputTextField resignFirstResponder];
        
        // game finished
        [self finishGame];
        
        // get selected word
        NSString *selectedWord;
        if (self.currentEvilGameplay) {
            selectedWord = [[gameplay getSelectedWord] objectAtIndex:arc4random()%[[gameplay getSelectedWord ]count]];
        } else {
            selectedWord = [[gameplay getSelectedWord] objectAtIndex:0];
        }
        
        // create message for popup
        NSString *msg = [NSString stringWithFormat:@"the word was '%@'",selectedWord];
        
        // show popup
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You suck..."
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (NSString *) setupWordDashes:(int)wordDashes {
    // create a mutable string
    NSMutableString *dashString = [[NSMutableString alloc]init];
    
    // add "_ " to string
    for (int i = 0; i < wordDashes; i++) {
        [dashString appendString:@"_ "];
    }
    
    return dashString;
}


- (void) finishGame {
    self.gameNotFinished = false;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.gameNotFinished forKey:@"gameNotFinished"];
    [defaults synchronize];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)showOptions:(id)sender
{
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - History View

- (void)historyViewControllerDidFinish:(HistoryViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showHistory:(id)sender
{
    HistoryViewController *controller = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
