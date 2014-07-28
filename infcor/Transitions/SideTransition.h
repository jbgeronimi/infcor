#import <Foundation/Foundation.h>

@interface SideTransition : NSObject <UIViewControllerAnimatedTransitioning, UIDynamicAnimatorDelegate>

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) id<UIViewControllerContextTransitioning> transitionContext;

@end
