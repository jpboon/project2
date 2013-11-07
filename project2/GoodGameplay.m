//
//  GoodGameplay.m
//  project2
//
//  Created by johan on 10/6/13.
//  Copyright (c) 2013 Johan Boon. All rights reserved.
//

#import "GoodGameplay.h"

@implementation GoodGameplay

NSArray *plistArray;
NSMutableArray *wordArray;

@synthesize pickedWord = _pickedWord;

- (void) selectAWordWithSize: (int) size {
    // load plist file into array
    plistArray = [[NSArray alloc] initWithContentsOfFile:
                 [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"]];
    
    // init wordArray
    wordArray = [[NSMutableArray alloc] init];
    
    // add size length words to wordArray
    for (NSString *word in plistArray) {
        if([word length] == size) {
            [wordArray addObject:word];
        }
    }

    // init pickedWord
    self.pickedWord = [[NSMutableArray alloc] init];
    
    // pick random word from wordArray
    [self.pickedWord addObject:[wordArray objectAtIndex:arc4random()%[wordArray count]]];
}


- (void) loadArrayWithWords: (NSArray *) words {
    // init pickedWord
    self.pickedWord = [[NSMutableArray alloc] init];
    // load pickedWord
    self.pickedWord = words.mutableCopy;
}


- (NSString *) lookupChars: (char) ch inWord: (NSMutableString *) currentWord {

    Boolean nothingChanged = true;
    
    // copy pickedWord to tempWord
    NSMutableString *tempWord = [[self.pickedWord objectAtIndex:0] mutableCopy];
    int charIndex = -1;
    
    do {
        // get index from char in tempWord
        charIndex = [self getIndexOf:ch inWord: tempWord];
        
        
        if (charIndex != -1) {
            // remove char from tempword
            [tempWord replaceCharactersInRange:NSMakeRange(charIndex, 1) withString:(@" ")];
            
            // add char to currentWord
            charIndex *= 2;
            [currentWord replaceCharactersInRange:NSMakeRange(charIndex, 1) withString:
                                            ([NSString stringWithFormat:@"%c", ch])];
            
            // something changed
            nothingChanged = false;
        }
        
    } while (charIndex != -1);


    if (nothingChanged) {
        return nil;
    } else {
        return currentWord;
    }
}


- (NSArray *) getSelectedWord {
    return self.pickedWord;
}

- (int) getIndexOf: (char) ch inWord: (NSString *) word {
    for (int i = 0; i < word.length; i++) {
        if (ch == [word characterAtIndex:i]) {
            return i;
        }
    }
    return -1;
}

@end
