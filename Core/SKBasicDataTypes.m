//
//  SVGBasicDataTypes.m
//  SVGPad
//
//  Created by adam applecansuckmybigtodger on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SVGBasicDataTypes.h"

const SVGLength SVGLengthZero = { 0.0, SVGLengthTypeUnknown };

/** Only supports raw float numbers now, and pretends they are pixels */
SVGLength SVGLengthFromNSString( NSString* value )
{
	SVGLength result = { [value floatValue], SVGLengthTypePx };
	return result;
}

SVGLength SVGLengthGetWidth( CGRect rect )
{
	SVGLength result = { CGRectGetWidth(rect), SVGLengthTypePx };
	return result;
}

SVGLength SVGLengthGetHeight( CGRect rect )
{
	SVGLength result = { CGRectGetHeight(rect), SVGLengthTypePx };
	return result;
}

CGFloat SVGLengthAsPixels( SVGLength len )
{
	switch( len.type )
	{
		case SVGLengthTypeUnknown:
		case SVGLengthTypeNumber:
		case SVGLengthTypePercentage:
		case SVGLengthTypeEms:
		case SVGLengthTypeExs:
		case SVGLengthTypeCm:
		case SVGLengthTypeMm:
		case SVGLengthTypeIn:
		case SVGLengthTypePt:
		case SVGLengthTypePc:
		{
			NSCAssert( FALSE, @"Can't convert this particular SVGLength type to pixels" );
		}
			
		case SVGLengthTypePx:
			return len.value;
	}
}

/*! Currently returns length-as-pixels (even though Apple has 4x real pixels to the apple points, right now the SVG lib does NOTHING special to handle Retina displays)
 
 TODO: add Retina support to SVGKit, and when it works: this method should perhaps return pixels / (points/pixel)
 */
CGFloat SVGLengthAsApplePoints( SVGLength len )
{
	return SVGLengthAsPixels(len);
}

@implementation SVGBasicDataTypes

@end
