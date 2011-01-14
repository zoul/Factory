@protocol Clock <NSObject>
- (CFAbsoluteTime) currentTime;
@end

@interface RealTimeClock : NSObject <Clock> {}
@end

@interface BrokenClock : NSObject <Clock> {}
@end