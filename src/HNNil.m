//  
//  HNNil.m
//  
//  Auther:
//       Ned Rihine <ned.rihine@gmail.com>
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
//

#import <hezelnut/HNNil.h>


@implementation HNNil


static HNNil* shared_nil_object = nil;


+ (id) instance {
    if ( shared_nil_object == nil )
        shared_nil_object = [ [ HNNil alloc ] init ];
    return shared_nil_object;
}


+ (id) alloc {
    if ( shared_nil_object == nil )
        shared_nil_object = [ super alloc ];
    return shared_nil_object;
}


- (id) init {
    if ( shared_nil_object == nil )
        shared_nil_object = [ [ HNNil alloc ] init ];
    return shared_nil_object;
}


- (BOOL) isNil { return YES; }


- (BOOL) notNil { return NO; }
@end


// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
