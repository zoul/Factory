@interface ClassProperty : NSObject
{
    NSString *name;
    NSString *attributes;
}

@property(readonly) NSString *name;
@property(readonly) NSString *attributes;
@property(readonly) Class classType;

- (id) initWithName: (NSString*) newName attributes: (NSString*) attString;

@end
