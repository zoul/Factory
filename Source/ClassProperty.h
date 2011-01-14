#import "PropertyAttribute.h"

@interface ClassProperty : NSObject {}

@property(readonly, retain) NSString *name;
@property(readonly, retain) PropertyAttribute *attributes;

- (id) initWithName: (NSString*) newName attributes: (NSString*) attString;
+ (id) propertyWithName: (NSString*) newName attributes: (NSString*) attString;
- (BOOL) canBeSatisfiedBy: (Class) componentType;

@end
