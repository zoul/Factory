#import "Component.h"

@interface Factory : NSObject {}

- (Component*) addComponent: (Class) component;
- (void) addSingleton: (id) singleton;

- (id) assemble: (Class) compType;
- (void) wire: (id) instance;

@end
