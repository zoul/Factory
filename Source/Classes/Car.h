@interface Engine : NSObject {}
@end

@interface Transmission : NSObject {}
@end

@interface Car : NSObject
{
    Engine *engine;
    Transmission *transmission;
    NSUInteger maxSpeed;
}

@property(retain) Engine *engine;
@property(retain) Transmission *transmission;
@property(readonly) NSUInteger maxSpeed;

@end
