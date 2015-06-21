//
//  DropTransitionAnimator.m
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/21/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "DropTransitionAnimator.h"

static NSTimeInterval const kDefaultDuration = 1.0;

@interface DropTransitionAnimator () <UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, assign) NSTimeInterval finishTime;
@property (nonatomic, assign) BOOL elapsedTimeExceededDuration;
@property (nonatomic, strong) UIAttachmentBehavior *attachBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@end

@implementation DropTransitionAnimator

- (id)init
{
    self = [super init];
    if (self) {
        _duration = kDefaultDuration;
    }
    return self;
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    UIView *containerView = [self.transitionContext containerView];
    CGFloat xContact = CGRectGetMaxX(containerView.bounds);
    if (p.x < xContact) {
        [self removeChildBehavior:behavior];
        [self.animator removeBehavior:behavior];
        self.collisionBehavior = nil;
    }
}

#pragma mark - UIDynamicAnimatorDelegate

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    // Presenting
    if (self.appearing) {
        if (self.elapsedTimeExceededDuration) {
            UIView *toView = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
            UIView *containerView = [self.transitionContext containerView];
            toView.center = containerView.center;
            self.elapsedTimeExceededDuration = NO;
        }
        
        [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
        
        // Remove all child behaviors
        for (UIDynamicBehavior *behavior in self.childBehaviors) {
            [self removeChildBehavior:behavior];
        }
        [animator removeAllBehaviors];
        self.transitionContext = nil;
    }
    // Dismissing
    else {
        if (self.attachBehavior) {
            [self removeChildBehavior:self.attachBehavior];
            self.attachBehavior = nil;
            [animator addBehavior:self];
            NSTimeInterval duration = [self transitionDuration:self.transitionContext];
            self.finishTime = 1./3. * duration + [animator elapsedTime];
        }
        else {
            UIView *fromView = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
            UIView *toView = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
            [fromView removeFromSuperview];
            toView.userInteractionEnabled = YES;
            
            [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
            for (UIDynamicBehavior *behavior in self.childBehaviors) {
                [self removeChildBehavior:behavior];
            }
            [animator removeAllBehaviors];
            self.transitionContext = nil;
        }
    }
}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{

}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    self.transitionContext = transitionContext;
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:containerView];
    animator.delegate = self;
    self.animator = animator;
    
    // Presenting
    if (self.appearing) {
        fromView.userInteractionEnabled = NO;
        
        CGRect fromViewInitialFrame = [transitionContext initialFrameForViewController:fromVC];
        CGRect toViewInitialFrame = toView.frame;
        toViewInitialFrame.origin.y -= CGRectGetHeight(toViewInitialFrame);
        toViewInitialFrame.origin.x = CGRectGetWidth(fromViewInitialFrame) / 2.0 - CGRectGetWidth(toViewInitialFrame) / 2.0;
        toView.frame = toViewInitialFrame;
        
        [containerView addSubview:toView];
        
        UIDynamicItemBehavior *bodyBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[toView]];
        bodyBehavior.elasticity = 0.3;
        [bodyBehavior addItem:toView];
        bodyBehavior.allowsRotation = NO;
        
        // Gravity
        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[toView]];
        gravityBehavior.magnitude = 3.0;
        
        // Collision
        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[toView]];
        
        UIEdgeInsets insets = UIEdgeInsetsMake(toViewInitialFrame.origin.y,
                                               0,
                                               CGRectGetHeight(fromViewInitialFrame) / 2.0 - CGRectGetHeight(toViewInitialFrame) / 2.0,
                                               0);
        [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:insets];
        self.collisionBehavior = collisionBehavior;
        
        self.finishTime = duration + [self.animator elapsedTime];
        
        __weak DropTransitionAnimator *weakSelf = self;
        self.action = ^{
            __strong DropTransitionAnimator *strongSelf = weakSelf;
            if (strongSelf) {
                if ([strongSelf.animator elapsedTime] >= strongSelf.finishTime) {
                    strongSelf.elapsedTimeExceededDuration = YES;
                    [strongSelf.animator removeBehavior:strongSelf];
                }
            }
        };
        
        [self addChildBehavior:collisionBehavior];
        [self addChildBehavior:bodyBehavior];
        [self addChildBehavior:gravityBehavior];
        [self.animator addBehavior:self];
    }
    // Dismissing
    else {
        //Spring
        UIDynamicItemBehavior *bodyBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[fromView]];
        bodyBehavior.elasticity = 0.8;
        bodyBehavior.angularResistance = 5.0;
        bodyBehavior.allowsRotation = YES;
        
        // Gravity
        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[fromView]];
        gravityBehavior.magnitude = 3.0f;
        
        // Collision - inset bottom and right
        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[fromView]];
        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, -225, -50);
        [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:insets];
        collisionBehavior.collisionDelegate = self;
        self.collisionBehavior = collisionBehavior;
        
        // Attachment
        UIOffset offset = UIOffsetMake(70, -(CGRectGetHeight(fromView.bounds) / 2.0));
        
        CGPoint anchorPoint = CGPointMake(CGRectGetMaxX(fromView.bounds) - 40,
                                          CGRectGetMinY(fromView.bounds));
        anchorPoint = [containerView convertPoint:anchorPoint fromView:fromView];
        UIAttachmentBehavior *attachBehavior = [[UIAttachmentBehavior alloc] initWithItem:fromView
                                                                         offsetFromCenter:offset
                                                                         attachedToAnchor:anchorPoint];
        attachBehavior.frequency = 3.0;
        attachBehavior.damping = 0.3;
        attachBehavior.length = 40;
        self.attachBehavior = attachBehavior;
        
        // Add the child behaviors
        [self addChildBehavior:collisionBehavior];
        [self addChildBehavior:bodyBehavior];
        [self addChildBehavior:gravityBehavior];
        [self addChildBehavior:attachBehavior];
        [self.animator addBehavior:self];
        
        self.finishTime = (2./3.) * duration + [self.animator elapsedTime];
        
        __weak DropTransitionAnimator *weakSelf = self;
        self.action = ^{
            __strong DropTransitionAnimator *strongSelf = weakSelf;
            if (strongSelf) {
                if ([strongSelf.animator elapsedTime] >= strongSelf.finishTime) {
                    strongSelf.elapsedTimeExceededDuration = YES;
                    [strongSelf.animator removeBehavior:strongSelf];
                }
            }
        };
    }
}


@end
