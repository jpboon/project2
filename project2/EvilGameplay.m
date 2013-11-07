//
//  EvilGameplay.m
//  project2
//
//  Created by johan on 10/6/13.
//  Copyright (c) 2013 Johan Boon. All rights reserved.
//

#import "EvilGameplay.h"

@interface EvilGameplay()
- (NSString *) returnWord: (NSMutableString *) currentWord
                 withChar: (char) ch
               insideWord: (NSMutableString *) tempWord;

@end

@implementation EvilGameplay


@synthesize pickedWord = _pickedWord;

// fill pickedWord array with words from plist with length size
- (void) selectAWordWithSize: (int) size {
    // load plist file into array
    NSArray *plistArray = [[NSArray alloc] initWithContentsOfFile:
                  [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"]];
    
    // init wordArray
    self.pickedWord = [[NSMutableArray alloc] init];
    
    // add length size words to wordArray
    for (NSString *word in plistArray) {
        if([word length] == size) {
            [self.pickedWord addObject:word];
        }
    }
}


- (void) loadArrayWithWords: (NSArray *) words {
    // init wordArray
    self.pickedWord = [[NSMutableArray alloc] init];
    // load wordArray
    self.pickedWord = words.mutableCopy;
}


- (NSString *) lookupChars: (char) ch inWord: (NSMutableString *) currentWord {

	// array with set of arrays
	NSMutableArray *arraySet = [[NSMutableArray alloc] init];
	// name of arrays at first position in the array
	NSString *arrayName = currentWord;
	
    // create the first array for arraySet
    NSMutableArray *firstArray  = [[NSMutableArray alloc] init];
    [firstArray addObject:arrayName];

    // add array in arraySet
    [arraySet addObject:firstArray];

    // loop through all words in the array pickedWord
    for (NSString * word in self.pickedWord) {

        // get arrayName from tempWord
        arrayName = [self returnWord:currentWord.mutableCopy withChar:ch insideWord:word.mutableCopy];
        int arraysInArraySet = arraySet.count;
        
        // loop through all arrays from arraySet
        for (int i = 0; i < arraysInArraySet; i++) {
            // if arrayName already exists in an array in the arraySet
            if ([arrayName isEqualToString:[[arraySet objectAtIndex:i] objectAtIndex:0]]) {
                // add word to the array
                [[arraySet objectAtIndex:i] addObject:word];
                // exit for-loop
                break;

            // if arrayName not found at all
            } else if (i == arraysInArraySet -1) {
                    // create new array
                    NSMutableArray *newArray  = [[NSMutableArray alloc] init];
                    // add arrayName and word to newArray
                    [newArray addObject:arrayName];
                    [newArray addObject:word];
                    // add newArray to arraySet
                    [arraySet addObject:newArray];
            }
        }   
    }

	// pick the array with the most words from arraySet
    int indexOfLargestArray = -1;
    int arraySize = 0;

    // loop through all arrays from arraySet
    for (int i = 0; i < arraySet.count; i++) {
        if ([[arraySet objectAtIndex:i] count] > arraySize) {
            arraySize = [[arraySet objectAtIndex:i] count];
            indexOfLargestArray = i;
        }
    }

    // copy the largest array to pickedWord
    self.pickedWord = [arraySet objectAtIndex:indexOfLargestArray];
    
    // if currentWord not changed return nil
    if (currentWord == [self.pickedWord objectAtIndex:0]) {
        currentWord = nil;
    // else return arrayName
    } else {
        currentWord = [self.pickedWord objectAtIndex:0];
    }
    
    // remove the arrayName
    [self.pickedWord removeObjectAtIndex:0];

    return currentWord;
}

        
- (NSArray *) getSelectedWord {
    return self.pickedWord;
}


- (NSString *) returnWord: (NSMutableString *) curWord withChar: (char) ch
               insideWord:(NSMutableString *) tmpWord {
    
    int charIndex;
    
    do {
        // get index from char in tempWord
        charIndex = [self getIndexOf:ch inWord: tmpWord];
    
        if (charIndex != -1) {
            // remove char from tempword
            [tmpWord replaceCharactersInRange:NSMakeRange(charIndex, 1) withString:(@" ")];
        
            // add char to currentWord
            charIndex *= 2;
            [curWord replaceCharactersInRange:NSMakeRange(charIndex, 1) withString:
                ([NSString stringWithFormat:@"%c", ch])];
        }
 
    } while (charIndex != -1);

    return curWord;
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
