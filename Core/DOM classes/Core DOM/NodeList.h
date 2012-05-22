/*
 Implemented internally via an NSArray
 
 From SVG DOM, via CoreDOM:
 
 http://www.w3.org/TR/DOM-Level-2-Core/core.html#ID-536297177
 
 interface NodeList {
 Node               item(in unsigned long index);
 readonly attribute unsigned long    length;
 };

 */
#import <Foundation/Foundation.h>

@class Node;
#import "Node.h"

@interface NodeList : NSObject

@property(readonly) long length;

-(Node*) item:(int) index;

@end
