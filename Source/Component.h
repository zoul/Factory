@protocol Component

@property(readonly, retain) Class classType;
@property(readonly, nonatomic, copy) NSDictionary *properties;

- (id) instance;

@end
