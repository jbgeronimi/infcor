#import "SideTransition.h"

@implementation SideTransition

- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
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
    
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:toVC.view snapToPoint:CGPointMake(CGRectGetMidX(fromVC.view.frame), CGRectGetMidY(fromVC.view.frame))];
    snapBehavior.damping = 0.9;
    [self.animator addBehavior:snapBehavior];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.transitionContext completeTransition:YES];
}

@end
