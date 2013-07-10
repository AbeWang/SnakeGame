typedef enum {
    AWSnakeDirectionUp = 0,
    AWSnakeDirectionDown,
    AWSnakeDirectionRight,
    AWSnakeDirectionLeft
}AWSnakeDirection;

@interface AWSnake : NSObject

+ (AWSnake *)snakeInstance;

- (void)setBoundaryRow:(NSInteger)rowCount column:(NSInteger)columnCount;
- (void)eatFood;
- (void)moveWithDirection:(AWSnakeDirection)inDirection;

@property (readonly, nonatomic) NSMutableArray *bodyItems;
@property (readonly, nonatomic) AWSnakeDirection currentDirection;
@end


@interface AWSnakeBodyItem : NSObject

- (id)initWithRow:(NSInteger)inRow column:(NSInteger)inColumn;

@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger column;
@end
