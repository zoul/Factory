#import "ClassProperty.h"

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
