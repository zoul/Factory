#import "ClassProperty.h"

@implementation ClassProperty
@synthesize name, attributes;

- (id) initWithName: (NSString*) newName attributes: (NSString*) attString
{
    [super init];
    name = [newName retain];
    attributes = [attString retain];
    return self;
}

- (void) dealloc
{
    [attributes release];
    [name release];
    [super dealloc];
}

- (Class) classForEncoding: (NSString*) encoding
{
    if (![encoding hasPrefix:@"@"])
        return Nil;
    NSString *suffix = [encoding substringFromIndex:2];
    NSString *className = [suffix substringToIndex:[suffix length]-1];
    return NSClassFromString(className);
}

- (Class) classType
{
    NSAssert([attributes hasPrefix:@"T"], @"Invalid attribute string.");
    NSString *suffix = [attributes substringFromIndex:1];
    NSString *typeStr = [suffix substringToIndex:[suffix rangeOfString:@","].location];
    return [self classForEncoding:typeStr];
}

- (BOOL) readOnly
{
    return [attributes rangeOfString:@",R,"].location != NSNotFound ||
        [attributes hasSuffix:@",R"];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"<Property: %@>", name];
}

- (NSUInteger) hash
{
    return [name hash];
}

- (BOOL) isEqual: (id) object
{
    if (![object isMemberOfClass:[self class]])
        return NO;
    return [[object name] isEqual:name] &&
        [[object attributes] isEqual:attributes];
}

@end
