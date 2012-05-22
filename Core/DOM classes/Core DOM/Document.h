/*
//  Document.h

 NOT a Cocoa / Apple document,
 NOT an SVG document,
 BUT INSTEAD: a DOM document (blame w3.org for the too-generic name).
 
 Required for SVG-DOM
 
 c.f.:
 
 http://www.w3.org/TR/DOM-Level-2-Core/core.html#i-Document
 
 interface Document : Node {
 readonly attribute DocumentType     doctype;
 readonly attribute DOMImplementation  implementation;
 readonly attribute Element          documentElement;
 Element            createElement(in DOMString tagName)
 raises(DOMException);
 DocumentFragment   createDocumentFragment();
 Text               createTextNode(in DOMString data);
 Comment            createComment(in DOMString data);
 CDATASection       createCDATASection(in DOMString data)
 raises(DOMException);
 ProcessingInstruction createProcessingInstruction(in DOMString target, 
 in DOMString data)
 raises(DOMException);
 Attr               createAttribute(in DOMString name)
 raises(DOMException);
 EntityReference    createEntityReference(in DOMString name)
 raises(DOMException);
 NodeList           getElementsByTagName(in DOMString tagname);
 // Introduced in DOM Level 2:
 Node               importNode(in Node importedNode, 
 in boolean deep)
 raises(DOMException);
 // Introduced in DOM Level 2:
 Element            createElementNS(in DOMString namespaceURI, 
 in DOMString qualifiedName)
 raises(DOMException);
 // Introduced in DOM Level 2:
 Attr               createAttributeNS(in DOMString namespaceURI, 
 in DOMString qualifiedName)
 raises(DOMException);
 // Introduced in DOM Level 2:
 NodeList           getElementsByTagNameNS(in DOMString namespaceURI, 
 in DOMString localName);
 // Introduced in DOM Level 2:
 Element            getElementById(in DOMString elementId);
 };

 
 */

#import <Foundation/Foundation.h>

/** ObjectiveC won't allow this: @class Node; */
#import "Node.h"
@class Element;
#import "Element.h"
@class Comment;
#import "Comment.h"
@class CDATASection;
#import "CDATASection.h"
@class DocumentFragment;
#import "DocumentFragment.h"
@class EntityReference;
#import "EntityReference.h"
@class NodeList;
#import "NodeList.h"
@class ProcessingInstruction;
#import "ProcessingInstruction.h"

@interface Document : Node

@property(nonatomic,retain,readonly) DocumentType     doctype;
@property(nonatomic,retain,readonly) DOMImplementation  implementation;
@property(nonatomic,retain,readonly) Element          documentElement;


-(Element*) createElement:(NSString*) tagName;
-(DocumentFragment*) createDocumentFragment;
-(Text*) createTextNode:(NSString*) data;
-(Comment*) createComment:(NSString*) data;
-(CDATASection*) createCDATASection:(NSString*) data;
-(ProcessingInstruction*) createProcessingInstruction:(NSString*) target data:(NSString*) data;
-(Attr*) createAttribute:(NSString*) data;
-(EntityReference*) createEntityReference:(NSString*) data;
-(NodeList*) getElementsByTagName:(NSString*) data;

// Introduced in DOM Level 2:
-(Node*) importNode:(Node*) importedNode deep:(BOOL) deep;

// Introduced in DOM Level 2:
-(Element*) createElementNS:(NSString*) namespaceURI qualifiedName:(NSString*) qualifiedName;

// Introduced in DOM Level 2:
-(Attr*) createAttributeNS:(NSString*) namespaceURI qualifiedName:(NSString*) qualifiedName;

// Introduced in DOM Level 2:
-(NodeList*) getElementsByTagNameNS:(NSString*) namespaceURI qualifiedName:(NSString*) localName;

// Introduced in DOM Level 2:
-(Element*) getElementById:(NSString*) elementId;

@end
