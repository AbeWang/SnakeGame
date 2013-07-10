#import "AWSnakeViewController.h"
#import "AWGridView.h"
#import "AWSnake.h"

@implementation AWSnakeViewController
{
    NSTimer *timer;
    AWGridView *gridView;
    AWSnakeDirection direction;
}

- (void)dealloc
{
    [timer invalidate];
}
- (void)loadView
{
    [super loadView];
    gridView = [[AWGridView alloc] initWithFrame:self.view.bounds gridWidth:10.0];
    self.view = gridView;
    
    NSInteger rowCount = [[gridView gridInfo][@"rowCount"] integerValue];
    NSInteger columnCount = [[gridView gridInfo][@"columnCount"] integerValue];
    [[AWSnake snakeInstance] setBoundaryRow:rowCount column:columnCount];
    direction = [AWSnake snakeInstance].currentDirection;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(snakeMove) userInfo:nil repeats:YES];
    
    UISwipeGestureRecognizer *upGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(up:)];
    [upGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:upGestureRecognizer];
    UISwipeGestureRecognizer *downGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(down:)];
    [downGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downGestureRecognizer];
    UISwipeGestureRecognizer *leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(left:)];
    [leftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftGestureRecognizer];
    UISwipeGestureRecognizer *rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(right:)];
    [rightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightGestureRecognizer];
}

- (void)snakeMove
{
    [[AWSnake snakeInstance] moveWithDirection:direction];
    [self.view setNeedsDisplay];
}

- (void)up:(UISwipeGestureRecognizer *)gr
{
    direction = AWSnakeDirectionUp;
}
- (void)down:(UISwipeGestureRecognizer *)gr
{
    direction = AWSnakeDirectionDown;
}
- (void)left:(UISwipeGestureRecognizer *)gr
{
    direction = AWSnakeDirectionLeft;
}
- (void)right:(UISwipeGestureRecognizer *)gr
{
    direction = AWSnakeDirectionRight;
}

@end
