//
//  NSArray+MDP.m
//  MDPFramework
//
//  Created by 谢进展 on 14-4-6.
//  Copyright (c) 2014年 谢进展. All rights reserved.
//

#import "NSArray+MDF.h"


@implementation NSArray (MDF)

- (NSArray *)mdf_randomArray
{
    NSMutableArray *shuffledArray = [self mutableCopy];
    NSUInteger arrayCount = [shuffledArray count];
    
    for (NSUInteger i = arrayCount - 1; i > 0; i--) {
        NSUInteger n = arc4random_uniform((u_int32_t)i + 1);
        [shuffledArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return [shuffledArray copy];
}

- (NSArray *)mdf_randomArrayWithLimit:(NSUInteger)itemLimit
{
    if (!itemLimit) return [self mdf_randomArray];
    
    NSMutableArray *shuffledArray = [self mutableCopy];
    NSUInteger arrayCount = [shuffledArray count];
    
    NSUInteger loopCounter = 0;
    for (NSUInteger i = arrayCount - 1; i > 0 && loopCounter < itemLimit; i--) {
        NSUInteger n = (NSUInteger)arc4random_uniform((u_int32_t)i + 1);
        [shuffledArray exchangeObjectAtIndex:i withObjectAtIndex:n];
        loopCounter++;
    }
    
    NSArray *arrayWithLimit;
    if (arrayCount > itemLimit) {
        NSRange arraySlice = NSMakeRange(arrayCount - loopCounter, loopCounter);
        arrayWithLimit = [shuffledArray subarrayWithRange:arraySlice];
    } else
        arrayWithLimit = [shuffledArray copy];
    
    return arrayWithLimit;
}

- (id)mdf_randomObject {
	return [self objectAtIndex:[self randomIndex]];
}

- (int)randomIndex {
	return arc4random()%[self count];
}


- (id)mdf_safeObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (NSString*)mdf_jsonValue {
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0 // non-pretty printing
                                                     error:&error];
    if(error)
        NSLog(@"JSON Parsing Error: %@", error);
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
