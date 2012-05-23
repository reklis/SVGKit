//
//  ProcessingInstruction.m
//  SVGKit
//
//  Created by adam on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProcessingInstruction.h"

@interface ProcessingInstruction()
@property(nonatomic,retain,readwrite) NSString* target;
@property(nonatomic,retain,readwrite) NSString* data;
@end

@implementation ProcessingInstruction

@synthesize target;
@synthesize data;

@end
