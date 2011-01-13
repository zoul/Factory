#import "Component.h"

@interface Component ()
@property(retain) Class type;
@end

@implementation Component
@synthesize type, customInit, customSetup;

#pragma mark Initialization

+ (id) componentWithClass: (Class) newType
{
    return [[[self alloc] initWithClass:newType] autorelease];
}

- (id) initWithClass: (Class) newType
{
    [super init];
    [self setType:newType];
    return self;
}

- (void) dealloc
{
    [customSetup release];
    [customInit release];
    [type release];
    [super dealloc];
}

#pragma mark Instance Management

- (id) newInstance
{
    id instance = (customInit == nil) ?
        [[type alloc] init] : customInit();
    if (customSetup != nil)
        customSetup(instance);
    return [instance autorelease];
}

@end
