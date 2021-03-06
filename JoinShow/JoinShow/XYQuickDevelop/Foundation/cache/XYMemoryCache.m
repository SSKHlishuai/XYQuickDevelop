//
//  XYMemoryCache.m
//  JoinShow
//
//  Created by Heaven on 14-1-17.
//  Copyright (c) 2014年 Heaven. All rights reserved.
//

#import "XYMemoryCache.h"
#import "NSObject+XY.h"
#import "NSString+XY.h"

#undef	DEFAULT_MAX_COUNT
#define DEFAULT_MAX_COUNT	(48)

@implementation XYMemoryCache

DEF_SINGLETON( XYMemoryCache );

- (id)init
{
	self = [super init];
	if ( self )
	{
		_clearWhenMemoryLow = YES;
		_maxCacheCount = DEFAULT_MAX_COUNT;
		_cachedCount = 0;
		
		_cacheKeys = [[NSMutableArray alloc] init];
		_cacheObjs = [[NSMutableDictionary alloc] init];
        
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        [self registerMessage:UIApplicationDidReceiveMemoryWarningNotification selector:@selector(handleNotification:) source:nil];
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	}
    
	return self;
}

- (void)dealloc
{
	[self unregisterAllMessage];
	
	[_cacheObjs removeAllObjects];
    [_cacheObjs release];
	
	[_cacheKeys removeAllObjects];
	[_cacheKeys release];
	
    [super dealloc];
}

#pragma mark - XYCacheProtocol

- (BOOL)hasObjectForKey:(id)key
{
	return [_cacheObjs objectForKey:key] ? YES : NO;
}

- (id)objectForKey:(id)key
{
	return [_cacheObjs objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key
{
	if ( nil == key )
		return;
	
	if ( nil == object )
		return;
	
	_cachedCount += 1;
    
	while ( _cachedCount >= _maxCacheCount )
	{
		NSString * tempKey = [_cacheKeys objectAtIndex:0];
        
		[_cacheObjs removeObjectForKey:tempKey];
		[_cacheKeys removeObjectAtIndex:0];
        
		_cachedCount -= 1;
	}
    
	[_cacheKeys addObject:key];
	[_cacheObjs setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
	if ( [_cacheObjs objectForKey:key] )
	{
		[_cacheKeys removeObjectIdenticalTo:key];
		[_cacheObjs removeObjectForKey:key];
        
		_cachedCount -= 1;
	}
}

- (void)removeAllObjects
{
	[_cacheKeys removeAllObjects];
	[_cacheObjs removeAllObjects];
	
	_cachedCount = 0;
}

- (id)objectForKeyedSubscript:(id)key
{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setObject:obj forKey:key];
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	if ([notification.name isEqualToString:UIApplicationDidReceiveMemoryWarningNotification])
	{
		if ( _clearWhenMemoryLow )
		{
			[self removeAllObjects];
		}
	}
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

@end

