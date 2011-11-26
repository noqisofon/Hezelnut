//  
//  vmpr_mt19937.h
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
#ifndef Hezelnut_private_vmpr_mt19937_h
#define Hezelnut_private_vmpr_mt19937_h

#if defined(__OBJC__)
#   import <limits.h>
#else
#   include <limits.h>
#endif  /* defined(__OBJC__) */


/*!
 * \def MT_SIZE
 */
#define    MT_SIZE      624
/*!
 * \def MT_FACTOR
 */
#define    MT_FACTOR    397


struct vmpr_mt19937_state_t {
    unsigned index;  //!< インデックス。
    int flag;  //!< SSE2 が使用可能であれば 1。
    int coin_bits;  //!< NextBit での残りのビット。
#if INT_MAX == 32767
    union {
        uint32_t z;
#   if defined(BIG_ENDIAN)
        struct { short hi, lo; } s;
#   else
        struct { short lo, hi; } s;
#   endif  /* defined(BIG_ENDIAN) */
    } c;
#else
    uint32_t coin_save;  //!< NextByte での値を保持。
#endif  /* INT_MAX == 32767 */
    int byte_pos;  //!< NextByte で使用したバイト数。
#if INT_MAX == 32767
    union {
        uint32_t z;
#   if defined(BIG_ENDIAN)
        struct { unsigned char u3, u2, u1, u0 } s;
#   else
        struct { unsigned char u0, u2, u3, u4 } s;
#   endif  /* defined(BIG_ENDIAN) */
    } b;  //!< NextByte での値を保持。
#else
    uint32_t byte_save;
#endif  /* INT_MAX == 32767 */
    int32_t range;  //!< NextIntEx での前回の範囲。
    uint32_t base;  //!< NextIntEx での前回の基準値。
    int shift;  //!< NextIntEx での前回のシフト数。
    int normal_sw;  //!< NextNormal での残りを持っている。
    double normal_save;  //!< NextNormal での残り。
    union {
#ifdef HAVE_SSE2
        __m128i  m[(int)((MEXP - 128) / 104 + 2)];
#endif  /* def HAVE_SSE2 */
#ifdef WORD64
        uint64_t y[(int)((MEXP - 128) / 104 + 2) * 2];
#endif  /* def WORD64 */
        uint32_t x[(int)((MEXP - 128) / 104 + 2) * 4];
        double   d[(int)((MEXP - 128) / 104 + 2) * 2];
    } u;
#ifdef __cplusplus
#   ifdef __GNUC__
    vmpr_mt19937_state_t() { index = 0; }
#   else
    vmpr_mt19937_state_t();
#   endif  /* def __GNUC__ */
#endif  /* def __cplusplus */
};


typedef    struct vmpr_mt19937_state_t    state_t[1];
#ifdef __cplusplus
#   define   DECLARE_MT(_identifier_)    state_t _identifier_
#else
#   define   DECLARE_MT(_identifier_)    state_t _identifier_ = {{0}}
#endif  /* def __cplusplus */

typedef   struct vmpr_mt19937_state_t*    state_p;

extern    struct vmpr_mt19937_state_t     vmpr_random_default_mt[];
extern    volatile int32_t                vmpr_random_default_seed;
extern    char*                           vmpr_random_id_strings_tbl;


extern void vmpr_random_generate_normal(state_p);
#ifdef HAVE_SSE2
extern void vmpr_random_generate_sse2(state_p);
#endif  /* def HAVE_SSE2 */

extern void vmpr_random_init_mt(state_p, uint32_t);
extern void vmpr_random_init_mtex(state_p, uint32_t*, unsigned);
extern int32_t vmpr_random_next_intex(state_p, uint32_t);

extern double vmpr_random_next(state_p, double);

#endif  /* Hezelnut_private_vmpr_mt19937_h */
// Local Variables:
//   coding: utf-8
// End:
