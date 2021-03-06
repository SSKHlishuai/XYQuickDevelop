//
//  XYMemoryCache.h
//  JoinShow
//
//  Created by Heaven on 14-1-17.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//


#import "XYPrecompile.h"
#import "XYCacheProtocol.h"

@interface XYMemoryCache : NSObject <XYCacheProtocol>

XY_SINGLETON( XYMemoryCache );

@property (nonatomic, assign) BOOL					clearWhenMemoryLow;
@property (nonatomic, assign) NSUInteger			maxCacheCount;
@property (nonatomic, assign) NSUInteger			cachedCount;
@property (atomic, retain) NSMutableArray *			cacheKeys;
@property (atomic, retain) NSMutableDictionary *	cacheObjs;

@end
