#import "SVGSVGElement.h"

@interface SVGSVGElement ()

@property (nonatomic, readwrite) /*FIXME: should be SVGAnimatedLength instead*/ SVGLength x;
@property (nonatomic, readwrite) /*FIXME: should be SVGAnimatedLength instead*/ SVGLength y;
@property (nonatomic, readwrite) /*FIXME: should be SVGAnimatedLength instead*/ SVGLength width;
@property (nonatomic, readwrite) /*FIXME: should be SVGAnimatedLength instead*/ SVGLength height;
@property (nonatomic, readwrite) NSString* contentScriptType;
@property (nonatomic, readwrite) NSString* contentStyleType;
@property (nonatomic, readwrite) SVGRect viewport;
@property (nonatomic, readwrite) float pixelUnitToMillimeterX;
@property (nonatomic, readwrite) float pixelUnitToMillimeterY;
@property (nonatomic, readwrite) float screenPixelToMillimeterX;
@property (nonatomic, readwrite) float screenPixelToMillimeterY;
@property (nonatomic, readwrite) BOOL useCurrentView;
@property (nonatomic, readwrite) SVGViewSpec* currentView;
@property (nonatomic, readwrite) float currentScale;
@property (nonatomic, readwrite) SVGPoint* currentTranslate;

@end
