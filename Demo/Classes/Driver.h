#import "Car.h"

@interface Driver : NSObject {}

@property(readonly) Car *car;
@property(retain) NSString *name;

- (id) initWithName: (NSString*) newName;

@end
