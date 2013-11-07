//
//  FlipsideViewController.m
//  project2
//
//  Created by johan on 10/5/13.
//  Copyright (c) 2013 Johan Boon. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()
- (void) saveLocalStorage;
- (int) longestWordInPlist;
@end

@implementation FlipsideViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.wordLengthSlider.maximumValue = [self longestWordInPlist];
    
    // load local storage
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.wordLengthLabel.text = [defaults  stringForKey:@"wordLength"];
    self.guessesLabel.text = [defaults stringForKey:@"guesses"];
    self.wordLengthSlider.value = [[defaults stringForKey:@"wordLength"] intValue];
    self.guessesSlider.value = [[defaults stringForKey:@"guesses"] intValue];
    self.evilSwitch.on = [[defaults stringForKey:@"evilPlay"] boolValue];
}

- (IBAction)sliderWordLength:(id)sender {
    // put slider value into label
    UISlider *wl = (UISlider *) sender;
    self.wordLengthLabel.text = [NSString stringWithFormat:@"%i",  (int)wl.value];
    // save to local storage
    [self saveLocalStorage];
}

- (IBAction)sliderGuesses:(id)sender {
    // put slider value into label
    UISlider *g = (UISlider *) sender;
    self.guessesLabel.text = [NSString stringWithFormat:@"%i", (int)g.value];
    // save to local storage
    [self saveLocalStorage];
}

- (IBAction)switchEvil:(id)sender {
    // save to local storage
    [self saveLocalStorage];
}

- (void) saveLocalStorage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.wordLengthLabel.text forKey:@"wordLength"];
    [defaults setObject:self.guessesLabel.text forKey:@"guesses"];
    [defaults setBool:self.evilSwitch.on forKey:@"evilPlay"];
    [defaults synchronize];
}


- (int) longestWordInPlist {
    int size = 1;
    
    // load plist file into array
    NSArray *plistArray = [[NSArray alloc] initWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"]];
    
    // search longest word in array
    for (NSString *word in plistArray) {
        if(word.length > size) {
            size = word.length;
        }
    }
    return size;
}


- (IBAction)done:(id)sender {
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end






