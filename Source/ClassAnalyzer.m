#import "ClassAnalyzer.h"
#import "ClassProperty.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

@implementation ClassAnalyzer

- (NSArray*) propertiesOfSingleClass: (Class) classObject
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
    free(properties);
    return result;
}

- (NSArray*) propertiesOf: (Class) classObject
{
    NSMutableArray *properties = [NSMutableArray array];
    Class candidate = classObject;
    do {
        [properties addObjectsFromArray:[self propertiesOfSingleClass:candidate]];
        candidate = [candidate superclass];
    } while (candidate != Nil);
    return properties;
}

- (NSArray*) dependenciesOf: (Class) classObject
{
    NSArray *allProperties = [self propertiesOf:classObject];
    NSMutableArray *deps = [NSMutableArray array];
    for (ClassProperty *property in allProperties)
        if ([[property attributes] classType] != nil)
            [deps addObject:property];
    NSArray *excludes = [self propertiesOf:[NSObject class]];
    [deps removeObjectsInArray:excludes];
    return deps;
}

@end
