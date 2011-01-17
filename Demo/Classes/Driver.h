#import "Car.h"
#import "Clock.h"

@interface Driver : NSObject {}

@property(readonly) Car *car;
@property(retain) NSString *name;
@property(retain) id <Clock> clock;
@property(assign) id context;

- (id) initWithName: (NSString*) newName;

@end
