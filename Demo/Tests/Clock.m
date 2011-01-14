#import "Clock.h"

@implementation RealTimeClock

- (CFAbsoluteTime) currentTime
{
    return CFAbsoluteTimeGetCurrent();
}

@end

@implementation BrokenClock

- (CFAbsoluteTime) currentTime
{
    return 0;
}

@end