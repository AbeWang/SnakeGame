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
    gridView = [[AWGridView alloc] initWithFrame:self.view.bounds gridWidth:20.0];
    self.view = gridView;
    
    NSInteger rowCount = [[gridView gridInfo][@"rowCount"] integerValue];
    NSInteger columnCount = [[gridView gridInfo][@"columnCount"] integerValue];
	AWPositionItem *boundary = [[AWPositionItem alloc] initWithRow:rowCount column:columnCount];
	[AWSnake snakeInstance].boundaryItem = boundary;
    direction = [AWSnake snakeInstance].currentDirection;
    
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

	timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(snakeMove) userInfo:nil repeats:YES];
}

- (void)snakeMove
{
    [[AWSnake snakeInstance] moveWithDirection:direction completionHandler:^(NSError *error) {
		if (error) {
			[timer invalidate];
			if ([error code] == AWSnakeErrorCode_Move) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no ~~" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Restart", nil];
				[alert show];
			}
			return;
		}
	}];
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[[AWSnake snakeInstance] reset];
	timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(snakeMove) userInfo:nil repeats:YES];
}

@end
