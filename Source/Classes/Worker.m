#import "Worker.h"

@implementation Worker
@synthesize factory;

- (void) dealloc
{
    [factory release];
    [super dealloc];
}

@end
