#import "Car.h"
#import "Clock.h"

@interface Driver : NSObject {}

@property(readonly) Car *car;
@property(retain) NSString *name;
@property(retain) id <Clock> clock;

- (id) initWithName: (NSString*) newName;

@end
