@interface Engine : NSObject {}
@end

@interface Transmission : NSObject {}
@end

@interface Car : NSObject
{
    Engine *engine;
    Transmission *transmission;
}

@property(retain) Engine *engine;
@property(retain) Transmission *transmission;

@end
