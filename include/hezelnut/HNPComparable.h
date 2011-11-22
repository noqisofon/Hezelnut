#ifndef hezelnut_HNPComparable_h
#define hezelnut_HNPComparable_h


@protocol HNPComparable
/** @addgroup comparing */
- (BOOL) lessThan: (id <HNPComparable>)a_magnitude;
- (BOOL) lessOrEqual: (id <HNPComparable>)a_magnitude;
- (BOOL) greaterThan: (id <HNPComparable>)a_magnitude;
- (BOOL) greaterOrEqual: (id <HNPComparable>)a_magnitude;
- (BOOL) equals: (id <HNPComparable>)a_magnitude;

/**
 * レシーバが min 以上かつ max 以下であれば真を返します。
 */
- (BOOL) between: (id <HNPComparable>)min and: (id <HNPComparable>)max;


- (int) compareTo: (id <HNPComparable>)a_magnitude;
@end


#endif  /* hezelnut_HNPComparable_h */
// Local Variables:
//   coding: utf-8
//   mode: objc
// End:
