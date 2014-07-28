#import <Foundation/Foundation.h>

@interface SideDismissalTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) id<UIViewControllerContextTransitioning> transitionContext;
@end
