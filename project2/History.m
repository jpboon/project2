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
    
    // get plist
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *dataFilePath = [documentDirectory stringByAppendingPathComponent:@"history.plist"];

    // write to plist
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]) {
        NSMutableArray *anArray = [[NSArray alloc] initWithContentsOfFile:dataFilePath].mutableCopy;
        
        //NSMutableArray *anArray = arr.mutableCopy;
        
        // add to array
        [anArray addObject:historyScore];
        
        // remove score if more than 10 scores
        if (anArray.count > 10) {
            [anArray removeObjectAtIndex:0];
        }
        
        // write array to plist
        [anArray writeToFile:dataFilePath atomically:YES];
    }
}

@end


