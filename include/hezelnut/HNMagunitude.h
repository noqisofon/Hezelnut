#ifndef Hezelnut_HNMagunitude_h
#define Hezelnut_HNMagunitude_h

#import <hezelnut/HNObject.h>


/*! \interface HNMagunitude HNMagunitude.h
  
 */
@interface HNMagunitude : HNObject < HNPComparable >
/*! \name testing

 */
/*!
  レシーバか a_magunitude、何れか大きい値を返します。
 */
- (HNMagunitude *) max: (HNMagunitude *)a_magunitude;


/*!
  レシーバか a_magunitude、何れか小さい値を返します。
 */
- (HNMagunitude *) min: (HNMagunitude *)a_magunitude;
/*
 * 
 */
//- (HNMagunitude *) min: (HNMagunitude *)a_min ;

@end


#endif  /* Hezelnut_HNMagunitude_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
