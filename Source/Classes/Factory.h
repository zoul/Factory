@interface Factory : NSObject {}

- (void) addComponent: (id) component;
- (id) getComponent: (Class) compType;

@end
