#import "AssemblyTest.h"

@interface AssemblyTest ()
@property(assign) NSUInteger hookCallCount;
@end

@implementation AssemblyTest
@synthesize hookCallCount;

- (void) afterAssembling
{
    hookCallCount++;
}

- (BOOL) assembled
{
    return hookCallCount > 0;
}

@end
