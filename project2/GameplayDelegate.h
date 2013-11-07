//
//  GameplayDelegate.h
//  project2
//
//  Created by johan on 10/6/13.
//  Copyright (c) 2013 Johan Boon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameplayDelegate

// pick a word (or range of words) of length size
- (void) selectAWordWithSize: (int) size;

// load array of words
- (void) loadArrayWithWords: (NSArray *) words;

/* 
lookup the chars in the chosen word, add them to the currentWord and return it
example:
the chosen word = APPLE
the currentWord = ___LE
the char = P 
Then return _PPLE
*/
 - (NSString *) lookupChars: (char) ch inWord: (NSMutableString *) currentWord;

// help function to get index of char in a string
- (int) getIndexOf: (char) ch inWord: (NSString *) word;

// return the array of selected words
- (NSArray *) getSelectedWord;

@property (nonatomic, strong) NSMutableArray *pickedWord;

@end
