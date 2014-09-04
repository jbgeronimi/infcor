#import "SideTransition.h"

@implementation SideTransition

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7f;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toVC.view];
    
    CGRect fullFrame = [transitionContext initialFrameForViewController:fromVC];
    
    toVC.view.frame = CGRectMake(fullFrame.size.width + 16, 20, fullFrame.size.width - 40, fullFrame.size.height - 40);
        
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:[transitionContext containerView]];
    
    self.animator.delegate = self;
    
   /* UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:toVC.view snapToPoint:CGPointMake(CGRectGetMidX(fromVC.view.frame), CGRectGetMidY(fromVC.view.frame))];
    snapBehavior.damping = 10;
    [self.animator addBehavior:snapBehavior];*/
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0.6f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        toVC.view.frame = CGRectMake(20, 20, fullFrame.size.width - 40, fullFrame.size.height - 40);
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.transitionContext completeTransition:YES];
}

@end
