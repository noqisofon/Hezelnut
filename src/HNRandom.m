//  
//  HNRandom.m
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

#import <private/vmpr_mt19937.h>

#import <hezelnut/Random.h>


static HNRandom* hn_random_source;


@implementation HNRandom
+ (int) mtSize { return 624; }


+ (id) seed: (int)an_integer {
    return [ [ self basicNew: [ self mtSize ] + 1 ] setSeed: an_integer ];
}


+ (id) new {
    return [ [ self basicNew: [ self mtSize ] + 1 ] setSeed ];
}


+ (id) source {
    if ( [ hn_random_source isNil ] )
        hn_random_source = [ self new ];

    return hn_random_source;
}


+ (double) next {
    return [ [ self source ] next ];
}


+ (int) between: (int)low and: (int)high {
    return [ [ self source ] between: low and: high ];
}


- (double) chiSquare {
    return [ [ self source ] chiSquare: 1000 range: 100 ];
}
- (double) chiSquare: (int)n range: (int)r {
    int i;
    id fry = [ HNArray new: r withAll: 0 ];
    id temp;

    for ( i = 0; i < n; ++ i ) {
        temp = [ HNInteger value: [ self between: 1 and: r ] ];
        [ fry at: temp put: [ farry at:temp ] + 1 ];
    }
    t = [ HNInteger value: 0 ];
    for ( i = 0; i < r; ++ i ) {
        temp = [ temp plus: [ [ fry ] squared ] ];
    }
    [ fry free ];
    return ((double)r) * ([ t asInt32 ] / n) - n;
}


- atEnd { return NO; }


- (int) between: (int)low and: (int)high {
    int range = high - low + 1;
    int result = [ self nextLimit: range ];

    return result + low;
}


- (double) next {
    vmpr_random_next();
}
@end
