//
//  HistoryViewController.h
//  project2
//
//  Created by johan on 10/6/13.
//  Copyright (c) 2013 Johan Boon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistoryViewController;

@protocol HistoryViewControllerDelegate
- (void) historyViewControllerDidFinish:(HistoryViewController *)controller;
@end

@interface HistoryViewController : UIViewController

@property (weak, nonatomic) id <HistoryViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end