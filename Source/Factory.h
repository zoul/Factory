@interface Factory : NSObject {}

- (id) addComponent: (Class) component;
- (void) addSingleton: (id) singleton;
- (id) assemble: (Class) compType;

@end
