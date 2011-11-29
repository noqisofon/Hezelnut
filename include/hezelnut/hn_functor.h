//  
//  hn_functor.h
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
#ifndef Hezelnut_hn_functor_h
#define Hezelnut_hn_functor_h


typedef   void (*hn_action1_functor)(id obj);
typedef   void (*hn_action2_functor)(id obj0, id obj1);

typedef   bool (*hn_predicate1_functor)(id obj)
typedef   bool (*hn_predicate2_functor)(id left, id right);

typedef   id (*hn_filter1_functor)(id obj);
typedef   id (*hn_filter2_functor)(id obj0, id obj1);


#endif  /* Hezelnut_hn_functor_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
