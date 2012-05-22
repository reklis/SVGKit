/*
 SVG-DOM, via Core DOM:
 
 http://www.w3.org/TR/DOM-Level-2-Core/core.html#ID-637646024
 
 interface Attr : Node {
 readonly attribute DOMString        name;
 readonly attribute boolean          specified;
 attribute DOMString        value;
 // raises(DOMException) on setting
 
 // Introduced in DOM Level 2:
 readonly attribute Element          ownerElement;
 };
*/
#import <Foundation/Foundation.h>

@class Node;
#import "Node.h"
@class Element;
#import "Element.h"

@interface Attr : Node
@property(nonatomic,retain,readonly) NSString* name;
@property(nonatomic,readonly) BOOL specified;
@property(nonatomic,retain,readonly) NSString* value;

// Introduced in DOM Level 2:
@property(nonatomic,retain,readonly) Element* ownerElement;
};

@end
