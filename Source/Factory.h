@interface Factory : NSObject {}

- (void) addComponent: (Class) component;
- (void) addSingleton: (id) singleton;

- (id) assemble: (Class) compType;
- (void) wire: (id) instance;

@end
