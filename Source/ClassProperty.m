#import "ClassProperty.h"
#import <objc/runtime.h>

@interface ClassProperty ()
@property(retain) NSString *name;
@property(retain) PropertyAttribute *attributes;
@end

@implementation ClassProperty
@synthesize name, attributes;

#pragma mark Initialization

+ (id) propertyWithName: (NSString*) newName attributes: (NSString*) attString
{
    return [[[self alloc] initWithName:newName attributes:attString] autorelease];
}

- (id) initWithName: (NSString*) newName attributes: (NSString*) attString
{
    [super init];
    [self setName:newName];
    [self setAttributes:[PropertyAttribute attributeWithString:attString]];
    return self;
}

- (void) dealloc
{
    [attributes release];
    [name release];
    [super dealloc];
}

- (BOOL) canBeSatisfiedBy: (Class) componentType
{
    if ([attributes isReadOnly])
        return NO;

    if ([attributes classType] && [attributes classType] != componentType)
        return NO;

    for (NSString *protoName in [attributes protocolNames])
        if (!class_conformsToProtocol(componentType, NSProtocolFromString(protoName)))
            return NO;

    return YES;
}

#pragma mark Housekeeping

- (NSString*) description
{
    return [NSString stringWithFormat:@"<%@ 0x%x: %@, atts: %@>",
        [self class], self, name, [attributes encodedForm]];
}

- (NSUInteger) hash
{
    return [name hash];
}

- (BOOL) isEqual: (id) object
{
    return ([object class] == [self class]) ?
        [[object name] isEqual:name] && [[object attributes] isEqual:attributes] : NO;
}

@end
