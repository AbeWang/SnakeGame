@interface AWPositionItem : NSObject

- (id)initWithRow:(NSInteger)inRow column:(NSInteger)inColumn;

@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger column;
@end
