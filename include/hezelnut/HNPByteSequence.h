#ifndef Hezelnut_HNPByteSequence_h
#define Hezelnut_HNPByteSequence_h


@protocol HNPByteSequence
/*! \addtogroup accessing */
/*! \{ */
/*!
    レシーバの index 番目の値を返します。
 */
- (uint8_t) byteAt: (int)index;
/*!
    レシーバの index 番目の値を value に置き換えます。
 */
- (uint8_t) byteAt: (int)index put: (uint8_t)value;

/*! \} */

@end


#endif  /* Hezelnut_HNPByteSequence_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
