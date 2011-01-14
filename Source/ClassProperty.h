@interface ClassProperty : NSObject {}

@property(readonly, retain) NSString *name;
@property(readonly, retain) NSString *attributes;
@property(readonly) Class classType;
@property(readonly) BOOL isReadOnly;

- (id) initWithName: (NSString*) newName attributes: (NSString*) attString;

@end
