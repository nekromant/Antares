#ifndef PRINTK_H
#define PRINTK_H

#ifdef DEBUG
#define dbg(...) printk(__VA_ARGS__)
#endif

#ifdef CONFIG_LIB_PRINTK_TIMESTAMP
void printk(const char *fmt, /*args*/ ...);
#endif

#endif
