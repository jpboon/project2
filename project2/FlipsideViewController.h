//
//  FlipsideViewController.h
//  project2
//
//  Created by johan on 10/5/13.
//  Copyright (c) 2013 Johan Boon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;

@end


@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UILabel *wordLengthLabel;
@property (nonatomic, strong) IBOutlet UILabel *guessesLabel;
@property (nonatomic, strong) IBOutlet UISlider *wordLengthSlider;
@property (nonatomic, strong) IBOutlet UISlider *guessesSlider;
@property (nonatomic, strong) IBOutlet UISwitch *evilSwitch;

- (IBAction)done:(id)sender;
- (IBAction)sliderWordLength:(id)sender;
- (IBAction)sliderGuesses:(id)sender;
- (IBAction)switchEvil:(id)sender;

@end
