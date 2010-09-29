#import "Car.h"

@implementation Car
@synthesize engine;

- (void) dealloc
{
    [engine release];
    [super dealloc];
}

@end
