//
//  Animation1ViewController.swift
//  AnimationDemo
//
//  Created by 郭建斌 on 16/5/13.
//  Copyright © 2016年 郭建斌. All rights reserved.
//

import UIKit
//交互式动画
class Animation1ViewController: UIViewController ,UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning,UIViewControllerInteractiveTransitioning{

    var navigationOperation: UINavigationControllerOperation?
    
//    var interactivePopTransition: UIPercentDrivenInteractiveTransition!
    
    var transitioningView: UIView?
    
    var transitioningContext:UIViewControllerContextTransitioning?
    
    var isTransiting:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        
        let  screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(Animation1ViewController.handlePopRecognizer(_:)))
        
        screenEdgePanGestureRecognizer.edges = UIRectEdge.Left
        
        self.navigationController!.view.addGestureRecognizer(screenEdgePanGestureRecognizer)
        
        
        
        // Do any additional setup after loading the view.
    }

    func handlePopRecognizer(screenEdgePanGestureRecognizer:UIScreenEdgePanGestureRecognizer) -> Void {
        
        let point = screenEdgePanGestureRecognizer.translationInView(self.navigationController?.view).x
        var progress:CGFloat!
        
        let width = self.view.bounds.size.width
        
        progress = point / width
    
        
        progress = min(1.0, max(0.0, progress))
        
        if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Began {
            isTransiting = true
//            self.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
            
            
        }else if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Changed
        {
            updateInteractiveTransition(progress)
        }
        else if screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Ended || screenEdgePanGestureRecognizer.state == UIGestureRecognizerState.Cancelled
        {
//            if progress > 0.5 {
//                self.interactivePopTransition.finishInteractiveTransition()
//                self.interactivePopTransition = nil
//            }
//            else
//            {
//                self.interactivePopTransition.cancelInteractiveTransition()
//                self.interactivePopTransition = nil
//            }
            
            finishBy(progress < 0.5)
            isTransiting = false
        }
        
        
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if !self.isTransiting {
            return nil
        }
        
        return self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
       
        self.transitioningContext = transitionContext
        
        let containerView = transitioningContext!.containerView()
        
        let toViewController = transitioningContext!.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let fromViewController = transitioningContext!.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        containerView?.insertSubview((toViewController?.view)!, belowSubview: (fromViewController?.view)!)
        
        self.transitioningView = fromViewController?.view
    }
    
    
    func updateInteractiveTransition(percentComplete: CGFloat)
    {
        let scale = CGFloat(fabs(percentComplete - CGFloat(1.0)))
//        print(scale)
        self.transitioningView?.transform = CGAffineTransformMakeScale(scale, scale)
        transitioningContext?.updateInteractiveTransition(percentComplete)
    }
    
    func finishBy(cancelled:Bool) -> Void {
        if cancelled {
            UIView.animateWithDuration(0.5, animations: { 
                self.transitioningView!.transform = CGAffineTransformIdentity
                }, completion: ({
                completed in
                    self.transitioningContext!.cancelInteractiveTransition()
                    self.transitioningContext!.completeTransition(false)
                }))
        }
        else
        {
            UIView.animateWithDuration(0.5, animations: {
                self.transitioningView!.transform = CGAffineTransformMakeScale(0, 0)
                }, completion: ({
                    completed in
                    self.transitioningContext!.finishInteractiveTransition()
                    self.transitioningContext!.completeTransition(true)
                    
                }))
        }
        
    }
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        navigationOperation = operation
        
        return self
        
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let fromeViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        
        var destView:UIView!
        
        var destTransform:CGAffineTransform!
        
        if navigationOperation == UINavigationControllerOperation.Push {
            
            containerView?.insertSubview((toViewController?.view)!, aboveSubview: (fromeViewController?.view)!)
            destView = toViewController?.view
            
            destView.transform = CGAffineTransformMakeScale(0.1, 0.1)
            
            destTransform = CGAffineTransformMakeScale(1, 1)
            
        }
        else if navigationOperation == UINavigationControllerOperation.Pop
        {
            containerView?.insertSubview((toViewController?.view)!, belowSubview: (fromeViewController?.view)!)
            
            destView = fromeViewController?.view
            
            destTransform = CGAffineTransformMakeScale(0, 0)
            
            
        }
        
        UIView .animateWithDuration(transitionDuration(transitionContext), animations: {
            destView.transform = destTransform!
            }, completion: ({completed in
                
                if transitionContext.transitionWasCancelled()
                {
                    
                }
            
                transitionContext.completeTransition(true)
            }))
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
