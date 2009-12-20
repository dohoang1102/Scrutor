//
//  IterativeAlphabetaSearchStrategyTest.m
//  Scrutor
//
//  Created by Hubbie on 19/12/2009.
//  Copyright 2009 Stig Brautaset. All rights reserved.
//

#import "IterativeAlphabetaSearchStrategyTest.h"

#import "NegamaxStub.h"
#import "IterativeStub.h"
#import "IterativeAlphabetaSearchStrategy.h"
#import "AlphabetaSearchStrategy.h"

@implementation IterativeAlphabetaSearchStrategyTest

- (void)setUp {
    searcher = [IterativeAlphabetaSearchStrategy new];
}

- (void)tearDown {
    [searcher release];
}

#pragma mark -

- (void)testSearchSpaceExhausted {
    NegamaxStub *stub = [[NegamaxStub new] autorelease];
    searcher.timeInterval = 10.0; // Allow many seconds.
    
    NSDate *start = [NSDate date];
    id move = [searcher moveFromState:stub];
    NSTimeInterval duration = -[start timeIntervalSinceNow];
    
    STAssertTrue(duration < 0.1, @"Duration was %f", duration);
    STAssertEqualObjects(move, @"B", nil);

    STAssertEquals(stub.maxPlyVisited, 5u, @"reached max ply");
    STAssertTrue(searcher.foundEnd, @"reached max ply in all paths");
}

- (void)testUsesUpTime {
    IterativeStub *stub = [[IterativeStub new] autorelease];
    searcher.timeInterval = 0.1;

    NSDate *start = [NSDate date];
    id move = [searcher moveFromState:stub];
    NSTimeInterval duration = -[start timeIntervalSinceNow];
    
    STAssertNotNil(move, nil);
    STAssertTrue(stub.maxPlyVisited > 5u, nil);
    STAssertTrue(stub.maxPlyVisited < 9u, nil);
    STAssertEqualsWithAccuracy(duration, 0.1, 0.005, nil);
    STAssertFalse(searcher.foundEnd, @"Did not reach end in all paths");
    
    // Verify that a plain AlphaBeta to the highest completed level finds the same best move.
    AlphabetaSearchStrategy *ab = [[AlphabetaSearchStrategy new] autorelease];

    // Subtract 1 from the maxPlyVisited because that is the highest attempted level.
    ab.maxPly = stub.maxPlyVisited - 1;
    id move2 = [ab moveFromState:stub];
    STAssertEqualObjects(move, move2, nil);
}

#pragma mark -

- (void)testCopy {
    searcher.timeInterval = random();
    IterativeAlphabetaSearchStrategy *copy = [[searcher copy] autorelease];
    STAssertEqualObjects(copy, searcher, nil);
    STAssertEquals(copy.timeInterval, searcher.timeInterval, nil);
}

- (void)testCoding {
    searcher.timeInterval = random();
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"coding.data"];
    [NSKeyedArchiver archiveRootObject:searcher toFile:path];
    
    id unarchived = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    STAssertEqualObjects(unarchived, searcher, nil);
    STAssertNotNil(unarchived, nil);
}

@end
