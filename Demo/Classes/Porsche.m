#import "Porsche.h"

@implementation Porsche
@synthesize type;

- (void) dealloc
{
    [type release];
    [super dealloc];
}

@end
