#import "ClassAnalyzer.h"
#import "PropertyAttribute.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

@implementation ClassAnalyzer

- (NSDictionary*) propertiesOfSingleClass: (Class) classObject
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    unsigned int propCount = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &propCount);
    for (int i=0; i<propCount; i++) {
        NSString *name = [NSString
            stringWithCString:property_getName(properties[i])
            encoding:NSASCIIStringEncoding];
        NSString *attributes = [NSString
            stringWithCString:property_getAttributes(properties[i])
            encoding:NSASCIIStringEncoding];
        [result
            setObject:[PropertyAttribute attributeWithString:attributes]
            forKey:name];
    }
    free(properties);
    return result;
}

- (NSDictionary*) propertiesOf: (Class) classObject
{
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    Class candidate = classObject;
    do {
        [properties addEntriesFromDictionary:[self propertiesOfSingleClass:candidate]];
        candidate = [candidate superclass];
    } while (candidate != Nil);
    return properties;
}

- (NSDictionary*) dependenciesOf: (Class) classObject
{
    NSDictionary *allProperties = [self propertiesOf:classObject];
    NSMutableDictionary *deps = [NSMutableDictionary dictionary];
    [allProperties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj classType] != nil)
            [deps setObject:obj forKey:key];
    }];
    NSDictionary *excludes = [self propertiesOf:[NSObject class]];
    [deps removeObjectsForKeys:[excludes allKeys]];
    return deps;
}

@end
