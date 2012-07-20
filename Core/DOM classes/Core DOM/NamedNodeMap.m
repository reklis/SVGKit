//
//  NamedNodeMap.m
//  SVGKit
//
//  Created by adam on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NamedNodeMap.h"

@interface NamedNodeMap()
@property(nonatomic,retain) NSMutableDictionary* internalDictionary;
@property(nonatomic,retain) NSMutableDictionary* internalDictionaryOfNamespaces;
@end

@implementation NamedNodeMap

@synthesize internalDictionary;
@synthesize internalDictionaryOfNamespaces;

- (id)init {
    self = [super init];
    if (self) {
        self.internalDictionary = [NSMutableDictionary dictionary];
		self.internalDictionaryOfNamespaces = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    self.internalDictionary = nil;
	self.internalDictionaryOfNamespaces = nil;
	
    [super dealloc];
}

-(Node*) getNamedItem:(NSString*) name
{
	return [self.internalDictionary objectForKey:name];
}

-(Node*) setNamedItem:(Node*) arg
{
	Node* oldNode = [self.internalDictionary objectForKey:arg.nodeName];
	
	[self.internalDictionary setObject:arg forKey:arg.nodeName];
	
	return oldNode;
}

-(Node*) removeNamedItem:(NSString*) name
{
	Node* oldNode = [self.internalDictionary objectForKey:name];
	
	[self.internalDictionary removeObjectForKey:name];
	
	return oldNode;
}

-(unsigned long)length
{
	int count = [self.internalDictionary count];
	
	for( NSDictionary* namespaceDict in self.internalDictionaryOfNamespaces )
	{
		count += [namespaceDict count];
	}
	
	return count;
}

-(Node*) item:(unsigned long) index
{
	if( index < [self.internalDictionary count] )
		return [self.internalDictionary.allValues objectAtIndex:index];
	else
	{
		index -= self.internalDictionary.count;
		
		for( NSDictionary* namespaceDict in self.internalDictionaryOfNamespaces )
		{
			if( index < [namespaceDict count] )
				return [namespaceDict.allValues objectAtIndex:index];
			else
				index -= [namespaceDict count];
		}
	}
	
	return nil;
}

// Introduced in DOM Level 2:
-(Node*) getNamedItemNS:(NSString*) namespaceURI localName:(NSString*) localName
{
	NSMutableDictionary* namespaceDict = [self.internalDictionaryOfNamespaces objectForKey:namespaceURI];
	
	return [namespaceDict objectForKey:localName];
}

// Introduced in DOM Level 2:
-(Node*) setNamedItemNS:(Node*) arg
{
	NSMutableDictionary* namespaceDict = [self.internalDictionaryOfNamespaces objectForKey:arg.namespaceURI];
	if( namespaceDict == nil )
	{
		namespaceDict = [NSMutableDictionary dictionary];
		[self.internalDictionaryOfNamespaces setObject:namespaceDict forKey:arg.namespaceURI];
	}
	Node* oldNode = [namespaceDict objectForKey:arg.nodeName];
					   
	[namespaceDict setObject:arg forKey:arg.nodeName];
	
	return oldNode;
}

// Introduced in DOM Level 2:
-(Node*) removeNamedItemNS:(NSString*) namespaceURI localName:(NSString*) localName
{
	NSMutableDictionary* namespaceDict = [self.internalDictionaryOfNamespaces objectForKey:namespaceURI];
	Node* oldNode = [namespaceDict objectForKey:localName];
	
	[namespaceDict removeObjectForKey:localName];
	
	return oldNode;
}

#pragma mark - ADDITIONAL to SVG Spec: useful debug / output / description methods

-(NSString *)description
{
	return [NSString stringWithFormat:@"NamedNodeMap: NSDictionary(%@)", self.internalDictionary];
}


@end
