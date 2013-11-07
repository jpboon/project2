//
//  HistoryViewController.m
//  project2
//
//  Created by johan on 10/6/13.
//  Copyright (c) 2013 Johan Boon. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // load plist file into scores array
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *dataFilePath = [documentDirectory stringByAppendingPathComponent:@"history.plist"];
    NSArray *scores = [[NSArray alloc] initWithContentsOfFile:dataFilePath];
    
    // create infolabels
    UILabel *infolabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 200, 20)];
    UILabel *infolabel1 = [[UILabel alloc] initWithFrame:CGRectMake(190, 50, 140, 20)];
    
    // add font to infolabels
    infolabel.font = [UIFont boldSystemFontOfSize:15.0];
    infolabel1.font = [UIFont boldSystemFontOfSize:15.0];
    
    // add text to infolabels
    infolabel.text = @"Word Guessed";
    infolabel1.text = @"Wrong Guesses";
    
    // add the labels to the view
    [self.view addSubview:infolabel];
    [self.view addSubview:infolabel1];
    
    // iterate over values in the scores array
    int y = 80;
    for (NSString *score in scores) {
        // create labels
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 220, 20)];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(250, y, 40, 20)];
        
        // add font to labels
        label.font = [UIFont italicSystemFontOfSize:13.0];
        label1.font = [UIFont italicSystemFontOfSize:13.0];
        
        // add text to labels
        NSString *word;
        NSString *guesses;
        for (int i = 0; i < score.length; i++) {
            if (',' == [score characterAtIndex:i]) {
                word = [score substringFromIndex:i+1];
                guesses = [score substringToIndex:i];
            }
        }
        label.text = word;
        label1.text = guesses;
        
        // add the labels to the view
        [self.view addSubview:label];
        [self.view addSubview:label1];
        
        // the next label should be displayed below this one
        y += 30;
    }
     
}

- (IBAction)done:(id)sender {
    [self.delegate historyViewControllerDidFinish:self];
}

@end
