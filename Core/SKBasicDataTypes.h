/**
 SVGBasicDataTypes.h
 
 Contains structs needed to support SVGKit, and all the methods you need to manipulate, create, view those structs
 */

#ifndef SVG_BASIC_DATA_TYPES_H_
#define SVG_BASIC_DATA_TYPES_H_


#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

#endif


/**
 http://www.w3.org/TR/SVG11/types.html#InterfaceSVGLength
 
 // Length Unit Types
 const unsigned short SVG_LENGTHTYPE_UNKNOWN = 0;
 const unsigned short SVG_LENGTHTYPE_NUMBER = 1;
 const unsigned short SVG_LENGTHTYPE_PERCENTAGE = 2;
 const unsigned short SVG_LENGTHTYPE_EMS = 3;
 const unsigned short SVG_LENGTHTYPE_EXS = 4;
 const unsigned short SVG_LENGTHTYPE_PX = 5;
 const unsigned short SVG_LENGTHTYPE_CM = 6;
 const unsigned short SVG_LENGTHTYPE_MM = 7;
 const unsigned short SVG_LENGTHTYPE_IN = 8;
 const unsigned short SVG_LENGTHTYPE_PT = 9;
 const unsigned short SVG_LENGTHTYPE_PC = 10;
 
 readonly attribute unsigned short unitType;
 attribute float value setraises(DOMException);
 attribute float valueInSpecifiedUnits setraises(DOMException);
 attribute DOMString valueAsString setraises(DOMException);
*/
typedef enum SVGLengthType
{
	SVGLengthTypeUnknown,
	SVGLengthTypeNumber,
	SVGLengthTypePercentage,
	SVGLengthTypeEms,
	SVGLengthTypeExs,
	SVGLengthTypePx,
	SVGLengthTypeCm,
	SVGLengthTypeMm,
	SVGLengthTypeIn,
	SVGLengthTypePt,
	SVGLengthTypePc
} SVGLengthType;

/**
 When a <length> is used in an SVG presentation attribute, the syntax must match the following pattern:
 
 length ::= number ("em" | "ex" | "px" | "in" | "cm" | "mm" | "pt" | "pc" | "%")?
 */
typedef struct
{
	const float value;
	const SVGLengthType type;
} SVGLength;

// FIXME: only absolute widths and heights are supported (no percentages)
extern const SVGLength SVGLengthZero;

/** Only supports raw float numbers for now, and pretends they are pixels */
SVGLength SVGLengthFromNSString( NSString* value );

SVGLength SVGLengthGetWidth( CGRect rect );

SVGLength SVGLengthGetHeight( CGRect rect );

CGFloat SVGLengthAsPixels( SVGLength len );

CGFloat SVGLengthAsApplePoints( SVGLength len );

@interface SVGBasicDataTypes : NSObject

@end

#endif