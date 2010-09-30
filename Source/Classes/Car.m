#import "Car.h"

@implementation Engine
@end

@implementation Transmission
@end

@implementation Car
@synthesize engine, transmission;

- (void) dealloc
{
    [transmission release];
    [engine release];
    [super dealloc];
}

@end
