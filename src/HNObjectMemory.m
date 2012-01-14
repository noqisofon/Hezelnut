//  
//  HNObjectMemory.m
//  
//  Auther:
//       ned rihine <ned.rihine@gmail.com>
// 
//  Copyright (c) 2011 rihine All rights reserved.
// 
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
// 
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
// 
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import <hezelnut/HNSymbol.h>
#import <hezelnut/HNSemaphore.h>
#import <hezelnut/HNClass.h>
#import <hezelnut/HNFraction.h>
#import <hezelnut/HNLargeInteger.h>
#import <hezelnut/HNDate.h>
#import <hezelnut/HNTime.h>
#import <hezelnut/HNFileDescriptor.h>
#import <hezelnut/HNNamespace.h>
#import <hezelnut/HNProcessor.h>
#import <hezelnut/HNSystemDictionary.h>

#import <hezelnut/HNObjectMemory.h>


static id _changed_block00_(id sender, id arg)  {
    id a_symbol = [ arg at: 0 ],
        semaphore = [ arg at: 1 ];
    
    [ DLD update: a_symbol ];
    [ [ sender super ] changed: a_symbol ];
    [ semaphore signal ];

    return NIL;
}


@implementation HNObjectMemory
#ifdef HEZELNUT_HAVE_SYMBOL
+ (id) changed: (HNSymbol *)a_symbol {
    int priority;
    id semaphore;

    if ( [ a_symbol identityEquals: HN_LITERAL_SYMBOL(returnFromSnapshot) ] )
        priority = [ HNProcessor highIOPriority ];
    else
        priority = [ HNProcessor userSchedulingPriority ];

    if ( [ HNProcessor activePriority ] < priority ) {
        semaphore = [ HNSemaphore new ];

        [ HNBlock new: _changed_block00_
                   in: self
                 with: HN_LITERAL_ARRAY(a_symbol, semaphore)
               forkAt: prioriry ];
        [ semaphore wait ];
    } else {
        [ DLD update: a_symbol ];
        [ super changed: a_symbol ];
    }

    if ( [ a_symbol identityEquals: HN_LITERAL_SYMBOL(aboutToQuit) ] ) {
        [ HNProcessor activeProcess priotity: [ HNProcessor idlePriority ] ];
        [ HNProcessor yield ];
    }
    return self;
}
#endif  /* def HEZELNUT_HAVE_SYMBOL */


+ (id) initialize {
    [ HNObject initialize ];
    [ HNClass initialize ];
    [ HNFraction initialize ];
    [ HNLargeInteger initialize ];
    [ HNDate initialize ];
    [ HNTime initialize ];
    [ HNFileDescriptor initialize ];
    [ HNNamespace initialize ];
    [ HNProcessor initialize ];
    [ HNSystemDictionary initialize ];

    [ self changed: HN_LITERAL_SYMBOL(returnFromSnapshot) ];

    return self;
}


+ (id) current {
    return [ [ self new ] update ];
}


+ (id) addressOf: (id)an_object {
    return [ HNInvalidArgumentError signalOn: an_object
                                      reason: "Cannot extract address of immediate OOP" ];
}


+ (id) addressOfOOP: (id)an_object {
    return [ HNInvalidArgumentError signalOn: an_object
                                      reason: "Cannot extract address of immediate OOP" ];
}


+ (id) scavenge {
    return [ self primitiveFailed ];
}


+ (id) globalGarbageCollect {
    return [ self primitiveFailed ];
}


+ (id) compact {
    return [ self primitiveFailed ];
}


+ (id) incrementalGCStep {
    return [ self primitiveFailed ];
}


+ (id) finishIncrementalGC {
    return [ self primitiveFailed ];
}


+ (id) abort {
    return self;
}


+ (id) quit {
    return [ self quit: 0 ];
}
+ (id) quit: (int)exit_status {
    return [ HNWrongClassError signalOn: exit_status mustBe: HNSmallInteger ];
}
@end


// Local Variables:
//   coding: utf-8
// End:
