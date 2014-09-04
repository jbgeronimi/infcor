#import "SideDismissalTransition.h"

@implementation SideDismissalTransition


- (NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7f;
}

- (void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    // TODO: Create a UIDynamicAnimator instance using the transition context's containerView as the reference view
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:[transitionContext containerView]];
    
    // TODO: Create an instantaneous push behavior for fromVC.view that moves up and right by a factor of 10
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[fromVC.view] mode:UIPushBehaviorModeInstantaneous];
    push.pushDirection = CGVectorMake(0, -10);
    [self.animator addBehavior:push];
    
    // TODO: Create a gravity behavior for fromVC.view pulls the view down (but not to the left or right) by a factor of 3
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[fromVC.view]];
    gravity.gravityDirection = CGVectorMake(0, 3);
    [self.animator addBehavior:gravity];
    
    // TODO: Implement an action block on the push behavior.  Inside that action block, check if the containerView frame intersects with the fromVC view frame.  When they no longer intersect, complete the transition.
    push.action = ^{
        if (!CGRectIntersectsRect(fromVC.view.frame, [[transitionContext containerView] frame]
                                  )){
            [transitionContext completeTransition:YES];
        }
    };
    
}

@end
