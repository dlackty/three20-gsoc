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

#import "Three20UI/TTSplitNavigatorWindow.h"

// UI
#import "Three20UI/TTSplitNavigator.h"
#import "Three20UI/TTNavigator.h"

// Core
#import "Three20Core/TTDebug.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTSplitNavigatorWindow


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
  if (event.type == UIEventSubtypeMotionShake) {
		TTSplitNavigator *splitNavigator = [TTSplitNavigator splitNavigator];
		if (splitNavigator.leftNavigator.supportsShakeToReload) {
			[splitNavigator.leftNavigator reload];
		}
		
		if (splitNavigator.rightNavigator.supportsShakeToReload) {
			[splitNavigator.rightNavigator reload];
		}
  }
}


@end
