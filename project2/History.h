//
//  History.h
//  project2
//
//  Created by johan on 10/6/13.
//  Copyright (c) 2013 Johan Boon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject
// class method
+ (void) storeHighScoreWord: (NSString *) word andMistakes: (int) mistakes;
@end
