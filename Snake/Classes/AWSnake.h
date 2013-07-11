#import "AWPositionItem.h"

typedef enum {
    AWSnakeDirectionUp = 0,
    AWSnakeDirectionDown,
    AWSnakeDirectionRight,
    AWSnakeDirectionLeft
}AWSnakeDirection;

typedef enum {
	AWSnakeErrorCode_Move = -1
} AWSnakeErrorCode;

extern NSString *const kSnakeMoveErrorDomain;

@interface AWSnake : NSObject

+ (AWSnake *)snakeInstance;

- (void)reset;
- (void)moveWithDirection:(AWSnakeDirection)inDirection completionHandler:(void (^)(NSError*))inHandler;

@property (readonly, nonatomic) NSMutableArray *bodyItems;
@property (readonly, nonatomic) AWSnakeDirection currentDirection;
@property (strong, nonatomic) AWPositionItem *boundaryItem;
@end
