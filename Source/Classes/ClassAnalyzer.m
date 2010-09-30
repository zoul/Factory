#import "ClassAnalyzer.h"
#import "ClassProperty.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

@implementation ClassAnalyzer

- (NSArray*) propertiesOf: (Class) classObject
{
    NSMutableArray *result = [NSMutableArray array];
    unsigned int propCount = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &propCount);
    for (int i=0; i<propCount; i++) {
        NSString *name = [NSString
            stringWithCString:property_getName(properties[i])
            encoding:NSASCIIStringEncoding];
        NSString *attributes = [NSString
            stringWithCString:property_getAttributes(properties[i])
            encoding:NSASCIIStringEncoding];
        ClassProperty *property = [[ClassProperty alloc]
            initWithName:name attributes:attributes];
        [result addObject:property];
        [property release];
    }
    return result;
}

@end
