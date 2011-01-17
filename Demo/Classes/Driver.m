#import "Driver.h"

@implementation Driver
@synthesize name, clock, context;

- (id) initWithName: (NSString*) newName
{
    [super init];
    [self setName:newName];
    return self;
}

- (void) dealloc
{
    [name release];
    [clock release];
    [super dealloc];
}

- (Car*) car
{
    return nil;
}

@end
