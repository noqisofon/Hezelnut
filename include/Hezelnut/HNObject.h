

#import "Hezelnut/HNVersionMacros.h"



@protocol HNObject

/*!
 * レシーバのクラスを返します。
 */
- (CHNClass_ref) class;


/*!
 * レシーバのスーパークラスを返します。
 */
- (CHNClass_ref) superclass;


/*!
 * レシーバの注釈文字列を返します。
 */
- (HNString *) description;


/*!
 * レシーバを返します。
 */
- (id) self;


/*!
 * レシーバと anObject が等しければ真を返します。
 * 
 * \param anObject 比較したい別のオブジェクト。
 */
- (CHNBoolean) equals: (id)anObject;


/*!
 * レシーバと anObject が等しければ真を返します。
 */
- (CHNBoolean) identityEquals: (id)anObject;


/*!
 *
 */
- (CHNBoolean) isKindOf: (CHNClass_ref)aClass;


/*!
 *
 */
- (CHNBoolean) isMemberOf: (CHNClass_ref)aClass;


/*!
 *
 */
- (CHNBoolean) isNil;


/*!
 *
 */
- (CHNBoolean) notNil;


/*!
 *
 */
- (CHNBoolean) respondsToSelector: (SEL)aSelector;

@end



@protocol HNCopyable

/*!
 * レシーバのコピーを返します。
 */
- (id) copy;


/*!
 * レシーバの浅いコピーを返します。
 */
- (id) shallowCopy;


/*!
 * レシーバの深いコピーを返します。
 */
- (id) deepCopy;


/*!
 * コピー元を返します。
 */
- (id) postCopy;

@end



/*!
 * Hezelnut のクラスの全ての基本クラスです。
 */
@interface HNObject <HNObject>
{
    CHNClass_ref prototype_;
}


/*!
 * 
 */
+ (CHNClass_ref) class;


/*!
 * オブジェクトを生成して返します。
 */
+ (id) alloc;


/*!
 *
 */
+ (id) allocWithZone: (HNZone *)aZone;


/*!
 *
 */
+ (id) new;


/*!
 *
 */
+ (id) newWithZone: (HNZone *)aZone;


/*!
 * これまでに使用されていた全てのリソースを開放します。
 */
- (void) finalize;


/*!
 * レシーバのコピーを返します。
 */
- (id) copy;


/*!
 * レシーバの浅いコピーを返します。
 */
- (id) shallowCopy;


/*!
 * レシーバの深いコピーを返します。
 */
- (id) deepCopy;


/*!
 * コピー元を返します。
 */
- (id) postCopy;


/*!
 *
 */
- (CHNUInteger) hash;


@end


// Local Variables:
//   mode: objc
//   coding: utf-8
// End:
