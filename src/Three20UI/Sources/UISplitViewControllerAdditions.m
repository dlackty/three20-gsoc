//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#ifdef __IPHONE_3_2

#import "Three20UI/UISplitViewControllerAdditions.h"

// UI
#import "Three20UI/TTNavigator.h"
#import "Three20UI/TTNavigationController.h"

// UINavigator
#import "Three20UINavigator/TTURLMap.h"
#import "Three20UINavigator/UIViewController+TTNavigator.h"

// UICommon
#import "Three20UICommon/TTGlobalUICommon.h"
#import "Three20UICommon/UIViewControllerAdditions.h"

// Network
#import "Three20Network/TTURLRequestQueue.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */
@implementation UISplitViewController (TTCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)leftViewController {
  return [self.viewControllers objectAtIndex:0];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeftViewController:(UIViewController*)viewController {
	if (self.leftViewController != viewController) {
		self.viewControllers = [NSArray arrayWithObjects:viewController, self.rightViewController, nil]; 
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)rightViewController {
  return [self.viewControllers objectAtIndex:1];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRightViewController:(UIViewController*)viewController {
	if (self.rightViewController != viewController) {
		self.viewControllers = [NSArray arrayWithObjects:self.leftViewController, viewController, nil]; 
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController (TTCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)canContainControllers {
  return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)topSubcontroller {
  return [[self.viewControllers objectAtIndex:0] topViewController];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addSubcontroller:(UIViewController*)controller animated:(BOOL)animated
							transition:(UIViewAnimationTransition)transition {
	// TODO: check if it is UINavigationController
  if (animated && transition) {
    if ([self.leftViewController isKindOfClass:[TTNavigationController class]]) {
      [(TTNavigationController*)self.leftViewController pushViewController: controller
                                 animatedWithTransition: transition];
    } else {
      [(UINavigationController*)self.leftViewController pushViewController:controller animated:YES];
    }
  } else {
    [(UINavigationController*)self.leftViewController pushViewController:controller animated:animated];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)bringControllerToFront:(UIViewController*)controller animated:(BOOL)animated {
  if ([((UINavigationController*)self.leftViewController).viewControllers indexOfObject:controller] != NSNotFound
      && controller != self.leftViewController.topSubcontroller) {
    [(UINavigationController*)self.leftViewController popToViewController:controller animated:animated];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)keyForSubcontroller:(UIViewController*)controller {
  NSInteger controllerIndex = [((UINavigationController*)self.leftViewController).viewControllers indexOfObject:controller];
  if (controllerIndex != NSNotFound) {
    return [NSNumber numberWithInt:controllerIndex].stringValue;
  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)subcontrollerForKey:(NSString*)key {
  NSInteger controllerIndex = key.intValue;
  if (controllerIndex < self.viewControllers.count) {
    return [self.viewControllers objectAtIndex:controllerIndex];
  } else {
    return nil;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)persistNavigationPath:(NSMutableArray*)path {
  for (UIViewController* controller in ((UINavigationController*)self.leftViewController).viewControllers) {
    [[TTNavigator navigator] persistController:controller path:path];
  }
}


@end

#endif
