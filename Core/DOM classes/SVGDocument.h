//
//  SVGDocument.h
//  SVGKit
//
//  Created by adam on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Document.h"
#import "SVGSVGElement.h"

@interface SVGDocument : Document

@property (nonatomic, retain, readonly) NSString* title;
@property (nonatomic, retain, readonly) NSString* referrer;
@property (nonatomic, retain, readonly) NSString* domain;
@property (nonatomic, retain, readonly) NSString* URL;
@property (nonatomic, retain, readonly) SVGSVGElement* rootElement;

@end
