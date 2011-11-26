//  
//  HNClassDescription.m
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

#import <hezelnut/HNClassDescription.h>


@implementation HNClassDescription
#ifdef HEZELNUT_ENABLE_INNER_SMALLTALK_INTERPRETER
- (id) createGetMethod: (HNPString)what {
    return [ [ super createGetMethod: what ] methodCategory: @"accessing" ];
}
- (id) createGetMethod: (HNPString)what default: (id)value {
    return [ [ super createGetMethod: what default: value ] methodCategory: @"accessing" ];
}


- (id) createSetMethod: (HNPString)what {
    return [ [ super createSetMethod: what ] methodCategory: @"accessing" ];
}
#endif  /* def HEZELNUT_ENABLE_INNER_SMALLTALK_INTERPRETER */
@end


