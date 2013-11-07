//
//  History.m
//  project2
//
//  Created by johan on 10/6/13.
//  Copyright (c) 2013 Johan Boon. All rights reserved.
//

#import "History.h"

@implementation History

// store High score
+ (void) storeHighScoreWord: (NSString *) word andMistakes: (int) mistakes {
    // create history score string
    NSMutableString *historyScore = [NSString stringWithFormat:@"%i,%@", mistakes,word];
    
    // get plist path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"history.plist"];

    // create array for plist data
    NSMutableArray *plistArray = [[NSMutableArray alloc] init];
    
    // create filemanager object
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // check if plist exists
    if (![fileManager fileExistsAtPath:path]) {
        
        // create file
        NSError *error;
        NSString *bundle = [[NSBundle mainBundle]pathForResource:@"history" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:path error:&error];
        
        // add to array
        [plistArray addObject:historyScore];
        
        // write array to plist
        [plistArray writeToFile:path atomically:YES];
        
    } else {
        // copy plist to array
        plistArray = [[NSArray alloc] initWithContentsOfFile:path].mutableCopy;
        
        // add to array
        [plistArray addObject:historyScore];
        
        // remove score if more than 10 scores
        if (plistArray.count > 10) {
            [plistArray removeObjectAtIndex:0];
        }
        
        // write array to plist
        [plistArray writeToFile:path atomically:YES];
    }
}

@end


