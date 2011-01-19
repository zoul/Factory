#import "ClassComponent.h"

@interface ClassComponent ()
@property(retain) Class classType;
@end

@implementation ClassComponent
@synthesize classType, customInit, customSetup;

#pragma mark Initialization

+ (id) componentWithClass: (Class) newType
{
    return [[[self alloc] initWithClass:newType] autorelease];
}

- (id) initWithClass: (Class) newType
{
    [super init];
    [self setClassType:newType];
    return self;
}

- (void) dealloc
{
    [customSetup release];
    [customInit release];
    [classType release];
    [super dealloc];
}

#pragma mark Component

- (id) instance
{
    id instance = (customInit == nil) ?
        [[classType alloc] init] : customInit();
    if (customSetup != nil)
        customSetup(instance);
    return [instance autorelease];
}

@end
