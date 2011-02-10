#import "SingletonComponent.h"

@interface SingletonComponent ()
@property(retain) id instance;
@end

@implementation SingletonComponent
@synthesize instance;

+ (id) componentWithObject: (id) anObject
{
    return [[[self alloc] initWithObject:anObject] autorelease];
}

- (id) initWithObject: (id) anObject
{
    [super init];
    [self setInstance:anObject];
    return self;
}

- (void) dealloc
{
    [instance release];
    [super dealloc];
}

- (Class) classType
{
    return [instance class];
}

- (NSDictionary*) properties
{
    // There is nothing to be wired in a singleton
    return nil;
}

- (BOOL) isEqual: (id) object
{
    return ([object class] == [self class]) ?
        [[object instance] isEqual:instance] : NO;
}

- (NSUInteger) hash
{
    return [instance hash];
}

@end
