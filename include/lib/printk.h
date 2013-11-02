#ifndef LIB_PRINTK_H
#define LIB_PRINTK_H

#ifndef DEBUG_LEVEL
#define DEBUG_LEVEL 4
#endif
 
#ifndef COMPONENT
#define COMPONENT "???"
#endif

#define do_log(level, ...) __dbg_ # level (__VA_ARGS__)

#define err(...) printk(COMPONENT ": " __VA_ARGS__)
#define warn(...) __dbg_0(__VA_ARGS__)
#define info(...) __dbg_1(__VA_ARGS__)
#define dbg(...) __dbg_2(__VA_ARGS__)



#if DEBUG_LEVEL > 0 
#define __dbg_0(...) printk(COMPONENT ": " __VA_ARGS__)
#define D_WARN_ENABLED
#else
#define __dbg_0(...) { }
#endif

#if DEBUG_LEVEL > 1 
#define __dbg_1(...) printk(COMPONENT ": " __VA_ARGS__)
#define D_INFO_ENABLED
#else
#define __dbg_1(...) { }
#endif

#if DEBUG_LEVEL > 2 
#define __dbg_2(...) printk(COMPONENT ": " __VA_ARGS__)
#define D_DBG_ENABLED
#else
#define __dbg_2(...) { }
#endif

#if DEBUG_LEVEL > 3 
#define __dbg_3(...) printk(COMPONENT ": " __VA_ARGS__)
#else
#define __dbg_3(...) { }
#endif


void printk_R(const char *fmt, ...);


/* 
 * On AVR we use PROGMEM for printk fmt. 
 */

#ifdef CONFIG_ARCH_AVR
#include <avr/pgmspace.h>
void printk_P(const char *fmt, ...);
#define printk(fmt, ...) printk_P(PSTR(fmt), #__VA_ARGS__);
#define printk_R(fmt, ...) printk_R(PSTR(fmt), #__VA_ARGS__);

#else

#define printk(fmt, ...) printk_R(fmt, #__VA_ARGS__);
#define printk_R(fmt, ...) printk_R(fmt, #__VA_ARGS__);

#endif



#endif
