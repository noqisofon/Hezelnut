//  
//  HNBehavior.m
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

#import <hezelnut/hn_functor.h>
#import <hezelnut/HNCollection.h>
#import <hezelnut/HNOrderedCollection.h>
#import <hezelnut/HNSet.h>
#import <hezelnut/HNDictionary.h>
#import <hezelnut/HNString.h>
#import <hezelnut/HNSymbol.h>
#import <hezelnut/HNError.h>
#import <hezelnut/HNInvalidValueError.h>
#import <hezelnut/NHNotFoundError.h>

#import <hezelnut/HNBehavior.h>


@implementation HNBehavior
- (id) addInstVarName: (id <HNPString>)a_string {
    id new_instance_variables;
    id duplicated;
    id symbol;

    [ self validateIdentifier: a_string ];
    symbol = [ a_string asSymbol ];
    new_instance_variables = [ instance_variables_ isNil ]?
        /* ifTrue: */ HN_RITERAL_ARRAY(symbol):
        /* ifFalse: */ [ instance_variables_ copyWith: symbol ];
    duplicated = [ [ [ self superclass ] allInstVarNames ] includes: symbol ];
    [ self updateInstanceVars: new_instance_variables shape: [ self shape ] ];
    if ( duplicated )
        [ self compileAll ];
    [ self compileAllSubClasses ];

    return self;
}


- (id) removeInstVarName: (id <HNPString>)a_string {
    id new_instance_variables;
    id symbol;
    int index;

    symbol = [ a_string asSymbol ];
#ifdef HEZELNUT_ENABLE_BLOCK
    index = [ instance_variables_ findLast: ^(id each) { return [ each equals: symbol ] } ];
#else
    index = [ instance_variables_ lastIndexOf: symbol ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */

    if ( index == -1 ) {
#ifdef HEZELNUT_HEVE_NOT_FOUND_ERROR
        [ HNNotFoundError signalOn: symbol what: @"instance variable" ];
#else
        return self;
#endif  /* def HEZELNUT_HEVE_NOT_FOUND_ERROR */
    }
    new_instance_variables = [ instance_variables_ copyReplaceFrom: index
                                                                to: index
                                                              with: HN_RITERAL_EMPTY_ARRAY ];

    return [ [ [ self
                   updateInstanceVars: new_instance_variables shape: [ self shape ] ]
                 compileAll ]
               compileAllSubclasses ];
}


- (id) instanceVariableNames: (id <HNPCollectable>)inst_var_names {
    id variable_array;
    id old_inst_var_names;
    int old_size;
#ifndef HEZELNUT_ENABLE_BLOCK
    id it, each;
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    BOOL removed;
    BOOL changed;
    BOOL added;

    variable_array = [ self parseInstanceVariableString: inst_var_names ];
    variable_array = [ [ self subclassInstVarNames ] concat: variable_array ];
    old_inst_var_names = [ self allInstVarNames ];
    /*
      インスタンス変数が更新された場合、インスタンス変数やクラスインスタンスの仕様？とその全てのサブクラスを更新します。
     */
    if ( [ variable_array equals: old_inst_var_names ] )
        return self;
    [ self updateInstanceVars: variable_array shape: [ self shape ] ];
    /*
      このクラス、またはサブクラス変数が変更された場合、再<ins>コンパイル</ins>構成する必要があります。
     */
    old_size = [ old_inst_var_names size ];
    changed = [ variable_array size ] < old_size ||
        [ variable_array first: old_size ] != [ old_inst_var_names first: old_size ];
#ifdef HEZELNUT_ENABLE_BLOCK
    removed = [ old_inst_var_names anySatisfy: ^(id each) {
            return ![ variable_array includes: each ];
        } ];
#else
    it = [ old_inst_var_names iterator ];
    removed = NO;
    for ( ; [ it finished ]; [ it next ] ) {
        each = [ it current ];

        if ( ![ variable_array includes: each ] )
            removed = YES;
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */
#ifdef HEZELNUT_ENABLE_BLOCK
    added = [ variable_array anySatisfy: ^(id each) {
            return ![ variable_array includes: each ];
        } ];
#else
    it = [ variable_array iterator ];
    added = NO;
    for ( ; [ it finished ]; [ it next ] ) {
        each = [ it current ];

        if ( ![ variable_array includes: each ] )
            added = YES;
    }
#endif  /* def HEZELNUT_ENABLE_BLOCK */

    if ( !(changed | removed | added) )
        return self;
    if ( changed | removed )
        [ self compileAll ];
    return [ self compileAllsubclasses ];
}


- (id) parseVariableString: (id <HNPString>)a_string {
    id tokens = [ [ a_string subStrings ] asArray ];
#ifndef HEZELNUT_ENABLE_BLOCK
    id it = [ tokens iterator ];
    id token;

    for ( ; [ it finished ]; [ it next ] ) {
        token = [ it current ];

        [ self validateIdentifier: token ];
    }
#else
    [ token do: ^(id token) { [ self validateIdentifier: token ] } ];
#endif  /* def HEZELNUT_ENABLE_BLOCK */
    return tokens;
}


#ifdef HEZELNUT_ENABLE_INNER_SMALLTALK_INTERPRETER
- (id) createGetMethod: (id <HNPString>)what {
    return [ self compile: [ HNString format: @"%1 [\n\"\Answer the receiver's %1\"\n^%1\n]"
                                        with: what ] ];
}
- (id) createGetMethod: (id <HNPString>)what default: (id <HNPString>)value {
    return [ self compile: [ HNString format: @"%1 [\n\"Ansert the receiver's %1. It's default value is %2\"\n%1 isNil ifTrue: [ %1 := %2 ].\n^%1\n]"
                                        with: what, value ] ];
}


- (id) defineAsyncCFunc: (id <HNPString>)c_func_name_string withSelectorArgs: (id)selecter_and_args args: (id)args_array {
    id code = @"";
}
#endif  /* def HEZELNUT_ENABLE_INNER_SMALLTALK_INTERPRETER */
@end
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
