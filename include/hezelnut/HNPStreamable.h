#ifndef hezelnut_HNPStreamable_h
#define hezelnut_HNPStreamable_h


/*! \protocol HNPStreamable
  
 */
@protocol HNPStreamable
/*! \name accessing
  
 */
/*!
 * 次のオブジェクトにアクセスします。
 */
- (id) basicNext;


/*!
 * 次のオブジェクトと an_object を置き換えます。
 */
- (id) basicNextPut: (id)an_object;


/*!
 * a_collection の全ての要素をストリームに書き出します。
 */
- (id) basicNextPutAll: (id < HNPCollectable >)a_collection;


/*!
 * ストリームの内容を返します。
 */
- (id < HNPCollectable >) contents;

@end


#endif  /* hezelnut_HNPStreamable_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
