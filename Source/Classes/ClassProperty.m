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

- (id) classForEncoding: (NSString*) encoding
{
    if (![encoding hasPrefix:@"@"])
        return nil;
    NSString *suffix = [encoding substringFromIndex:2];
    NSString *className = [suffix substringToIndex:[suffix length]-1];
    return NSClassFromString(className);
}

- (Class) className
{
    NSAssert([attributes hasPrefix:@"T"], @"Invalid attribute string.");
    NSString *suffix = [attributes substringFromIndex:1];
    NSString *typeStr = [suffix substringToIndex:[suffix rangeOfString:@","].location];
    return [self classForEncoding:typeStr];
}

@end
