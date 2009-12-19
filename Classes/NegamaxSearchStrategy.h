//
//  NegamaxSearchStrategy.h
//  Scrutor
//
//  Created by Hubbie on 19/12/2009.
//  Copyright 2009 Stig Brautaset. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchStrategy.h"

@interface NegamaxSearchStrategy : NSObject < SearchStrategy > {
    NSUInteger _maxPly;
}

- (id)initWithMaxPly:(NSUInteger)maxPly_;

@end
