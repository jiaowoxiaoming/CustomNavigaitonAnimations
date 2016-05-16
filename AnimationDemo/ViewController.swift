//
//  ViewController.swift
//  AnimationDemo
//
//  Created by 郭建斌 on 16/5/13.
//  Copyright © 2016年 郭建斌. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UINavigationControllerDelegate,UIViewControllerAnimatedTransitioning,UIGestureRecognizerDelegate{

    var navigationOperation: UINavigationControllerOperation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController!.delegate = self
        
        let pop = UIPanGestureRecognizer(target: self.navigationController?.interactivePopGestureRecognizer?.delegate, action: (Selector("handleNavigationTransition:")))
        
        self.navigationController?.view .addGestureRecognizer(pop);
        
        pop.delegate = self
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (self.navigationController?.topViewController != self.navigationController?.viewControllers[0])
    }

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        navigationOperation = operation
       
        return self
        
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
            
            destTransform = CGAffineTransformMakeScale(0.1, 0.1)
            
        }
        
        
        UIView .animateWithDuration(transitionDuration(transitionContext), animations: { 
            destView.transform = destTransform!
            }, completion: ({completed in
                transitionContext.completeTransition(true)
            }))
    }

//    @IBAction func push(sender: UIButton) {
//        
//        let firstVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FirstViewController")
//        
//        self.navigationController?.pushViewController(firstVC, animated: true)
//    
//    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

