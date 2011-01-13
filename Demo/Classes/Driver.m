#import "Driver.h"

@implementation Driver
@synthesize name;

- (id) initWithName: (NSString*) newName
{
    [super init];
    [self setName:newName];
    return self;
}

- (void) dealloc
{
    [name release];
    [super dealloc];
}

- (Car*) car
{
    return nil;
}

@end
