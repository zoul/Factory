@interface Engine : NSObject {}
@end

@interface Transmission : NSObject {}
@end

@interface Car : NSObject {}

@property(retain) Engine *engine;
@property(retain) Transmission *transmission;

@end
