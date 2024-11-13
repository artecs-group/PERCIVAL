#include <stdio.h>
#include <stdint.h>

int padd_test() {
    int64_t a, b, c, d, e, f, g;

    a = 0x7FFEF4E807159380; // Posit  65812428845678592
    b = 0x7FFB64C18B7AA480; // Posit  196128704123456
    c = 0x8001EC309E70B4B7; // Posit -5897610247459392
    d = 0;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "pld    pt0,0(%4)      \n"
        "pld    pt1,0(%5)      \n"
        "pld    pt2,0(%6)      \n"

        "padd.s pt3,pt0,pt1    \n"
        "padd.s pt4,pt1,pt0    \n"
        "psd    pt3,0(%7)      \n"
        "psd    pt4,0(%8)      \n"

        "padd.s pt5,pt2,pt1    \n"
        "padd.s pt6,pt0,pt2    \n"
        "psd    pt5,0(%9)      \n"
        "psd    pt6,0(%10)     \n"

        : "=rm" (d), "=rm" (e), "=rm" (f), "=rm" (g)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f), "r" (&g)
        :
    );

    if (d == 0x7FFEF54137787229 && e == 0x7FFEF54137787229 
        && f == 0x8001EEFA2187AA00 && g == 0x7FFEEA6E1AE3AA17) {
        printf("PADD test OK\n");
        return 0;
    }
    else {
        printf("PADD test FAIL - Values: %lx %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f, g);
        return 1;
    }
}

int psub_test() {
    int64_t a, b, c, d, e, f, g;

    a = 0x7FFEF4E807159380; // Posit  65812428845678592
    b = 0x7FFB64C18B7AA480; // Posit  196128704123456
    c = 0x8001EC309E70B4B7; // Posit -5897610247459392
    d = 0;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "pld    pt0,0(%4)      \n"
        "pld    pt1,0(%5)      \n"
        "pld    pt2,0(%6)      \n"

        "psub.s pt3,pt0,pt1    \n"
        "psub.s pt4,pt1,pt0    \n"
        "psd    pt3,0(%7)      \n"
        "psd    pt4,0(%8)      \n"

        "psub.s pt5,pt2,pt1    \n"
        "psub.s pt6,pt0,pt2    \n"
        "psd    pt5,0(%9)      \n"
        "psd    pt6,0(%10)     \n"

        : "=rm" (d), "=rm" (e), "=rm" (f), "=rm" (g)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f), "r" (&g)
        :
    );

    if (d == 0x7FFEF48ED6B2B4D7 && e == 0x80010B71294D4B29 
        && f == 0x8001E9671B59BF6E && g == 0x7FFEFF61F3477CE9) {
        printf("PSUB test OK\n");
        return 0;
    }
    else {
        printf("PSUB test FAIL - Values: %lx %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f, g);
        return 1;
    }
}

int pmul_test() {
    int64_t a, b, c, d, e, f, g;

    a = 0x7DA0ACC49D84DC98; // Posit  658124.28845678491
    b = 0x7A32737B4D5FBA30; // Posit  19612.870412345637
    c = 0x827003EF9AA3FFC0; // Posit -589761.02474594209
    d = 0;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "pld    pt0,0(%4)      \n"
        "pld    pt1,0(%5)      \n"
        "pld    pt2,0(%6)      \n"

        "pmul.s pt3,pt0,pt1    \n"
        "pmul.s pt4,pt1,pt0    \n"
        "psd    pt3,0(%7)      \n"
        "psd    pt4,0(%8)      \n"

        "pmul.s pt5,pt2,pt1    \n"
        "pmul.s pt6,pt0,pt2    \n"
        "psd    pt5,0(%9)      \n"
        "psd    pt6,0(%10)     \n"

        : "=rm" (d), "=rm" (e), "=rm" (f), "=rm" (g)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f), "r" (&g)
        :
    );

    if (d == 0x7FCC056FE042E162 && e == 0x7FCC056FE042E162 
        && f == 0x80353A3C0D1D9F68 && g == 0x80165A149D00D885) {
        printf("PMUL test OK\n");
        return 0;
    }
    else {
        printf("PMUL test FAIL - Values: %lx %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f, g);
        return 1;
    }
}

int pdiv_test() {
    int64_t a, b, c, d, e, f, g, h, zero;

    a = 0x7DA0ACC49D84DC98; // Posit  658124.28845678491
    b = 0x7A32737B4D5FBA30; // Posit  19612.870412345637
    c = 0x827003EF9AA3FFC0; // Posit -589761.02474594209
    d = 0;
    e = 0;
    f = 0;
    g = 0;
    h = 1;
    zero = 0;

    asm volatile (
        "pld    pt0,0(%5)      \n"
        "pld    pt1,0(%6)      \n"
        "pld    pt2,0(%7)      \n"

        "pdiv.s pt3,pt0,pt1    \n"
        "pdiv.s pt4,pt1,pt0    \n"
        "psd    pt3,0(%8)      \n"
        "psd    pt4,0(%9)      \n"

        "pdiv.s pt3,pt2,pt1    \n"
        "pdiv.s pt4,pt0,pt2    \n"
        "pld    pt6,0(%13)     \n"
        "pdiv.s pt5,pt0,pt6    \n" // Division by zero
        "psd    pt3,0(%10)     \n"
        "psd    pt4,0(%11)     \n"
        "psd    pt5,0(%12)     \n"

        : "=rm" (d), "=rm" (e), "=rm" (f), "=rm" (g), "=rm" (h)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f), "r" (&g), "r" (&h), "r" (&zero)
        :
    );

    if (d == 0x6431C89571071403 && e == 0x1BA10C946A45AD04 
        && f == 0x9C7B8370900E763C && g == 0xBF129A2A6A366D6F && h == 0x8000000000000000) {
        printf("PDIV test OK\n");
        return 0;
    }
    else {
        printf("PDIV test FAIL - Values: %lx %lx %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f, g, h);
        return 1;
    }
}

int psqrt_test() {
    int64_t a, b, c, d, e, f;

    a = 0x7DA0ACC49D84DC98; // Posit  658124.28845678491
    b = 0x7A32737B4D5FBA30; // Posit  19612.870412345637
    c = 0x827003EF9AA3FFC0; // Posit -589761.02474594209
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "pld    pt0,0(%3)     \n"
        "pld    pt1,0(%4)     \n"
        "pld    pt2,0(%5)     \n"

        "psqrt.s pt3,pt0      \n"
        "psqrt.s pt4,pt1      \n"
        "psqrt.s pt5,pt2      \n"
        "psd    pt3,0(%6)     \n"
        "psd    pt4,0(%7)     \n"
        "psd    pt5,0(%8)     \n"

        : "=rm" (d), "=rm" (e), "=rm" (f)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f)
        :
    );

    if (d == 0x732B3FA425945DCD && e == 0x6C605E1F5731CD47 && f == 0x8000000000000000) {
        printf("PSQRT test OK\n");
        return 0;
    }
    else {
        printf("PSQRT test FAIL - Values: %lx %lx %lx %lx %lx %lx\n", 
            a, b, c, d, e, f);
        return 1;
    }
}

int pmin_test() {
    int64_t a, b, c, d, e, f, g;

    a = 0x7FFEF4E807159380; // Posit  65812428845678592
    b = 0x7FFB64C18B7AA480; // Posit  196128704123456
    c = 0x8001EC309E70B4B7; // Posit -5897610247459392
    d = 0;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "pld    pt0,0(%4)      \n"
        "pld    pt1,0(%5)      \n"
        "pld    pt2,0(%6)      \n"

        "pmin.s pt3,pt0,pt1    \n" 
        "pmin.s pt4,pt1,pt0    \n" 
        "pmin.s pt5,pt2,pt0    \n" 
        "pmin.s pt6,pt2,pt2    \n" 
        "psd    pt3,0(%7)      \n"
        "psd    pt4,0(%8)      \n"
        "psd    pt5,0(%9)      \n"
        "psd    pt6,0(%10)     \n"

        : "=rm" (d), "=rm" (e), "=rm" (f), "=rm" (g)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f), "r" (&g)
        :
    );

    if (d == 0x7FFB64C18B7AA480 && e == 0x7FFB64C18B7AA480 
        && f == 0x8001EC309E70B4B7 && g == 0x8001EC309E70B4B7) {
        printf("PMIN test OK\n");
        return 0;
    }
    else {
        printf("PMIN test FAIL - Values: %lx %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f, g);
        return 1;
    }
}

int pmax_test() {
    int64_t a, b, c, d, e, f, g;

    a = 0x7FFEF4E807159380; // Posit  65812428845678592
    b = 0x7FFB64C18B7AA480; // Posit  196128704123456
    c = 0x8001EC309E70B4B7; // Posit -5897610247459392
    d = 0;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "pld    pt0,0(%4)      \n"
        "pld    pt1,0(%5)      \n"
        "pld    pt2,0(%6)      \n"

        "pmax.s pt3,pt0,pt1    \n" 
        "pmax.s pt4,pt1,pt0    \n" 
        "pmax.s pt5,pt2,pt0    \n" 
        "pmax.s pt6,pt2,pt2    \n" 
        "psd    pt3,0(%7)      \n"
        "psd    pt4,0(%8)      \n"
        "psd    pt5,0(%9)      \n"
        "psd    pt6,0(%10)     \n"

        : "=rm" (d), "=rm" (e), "=rm" (f), "=rm" (g)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f), "r" (&g)
        :
    );

    if (d == 0x7FFEF4E807159380 && e == 0x7FFEF4E807159380 
        && f == 0x7FFEF4E807159380 && g == 0x8001EC309E70B4B7) {
        printf("PMAX test OK\n");
        return 0;
    }
    else {
        printf("PMAX test FAIL - Values: %lx %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f, g);
        return 1;
    }
}

int quire_test() {
    int64_t a, b, c, d, e, f;

    a = 0x4000000000000000; // Posit 1
    b = 0x4000000000000000; // Posit 1
    c = 0x4C00000000000000; // Posit 3
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "pld    pt3,0(%3)     \n"
        "pld    pt4,0(%4)     \n"
        "pld    pt5,0(%5)     \n"

        "qclr.s               \n"  // Quire: 0
        "qmadd.s  pt3,pt4     \n"  // Quire: 1
        "qmadd.s  pt5,pt5     \n"  // Quire: 10
        "qmsub.s  pt4,pt5     \n"  // Quire: 7
        "qround.s pt6         \n"
        "psd      pt6,0(%6)   \n"
        "qneg.s               \n"  // Quire: -7
        "qround.s pt6         \n"
        "psd      pt6,0(%7)   \n"
        "qclr.s               \n"  // Quire: 0
        "qround.s pt6         \n"
        "psd      pt6,0(%8)   \n"

        : "=rm" (d), "=rm" (e), "=rm" (f)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f)
        :
    );

    if (d == 0x5600000000000000 && e == 0xAA00000000000000 && f == 0x0000000000000000) {
        printf("QUIRE test OK\n");
        return 0;
    }
    else {
        printf("QUIRE test FAIL - Values: %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f);
        return 1;
    }
}

int pcvtws_test() {  // Pos to int
    int64_t a, b, c;
    int32_t d, e, f;

    a = 0x7F939D170024EA4B; // 658124288.2884
    b = 0x7F6EC2BEFF7B4A24; // 196128703.8704
    c = 0x806E6C7AFFFCD520; // -589761024.0247459
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "pld    pt0,0(%3)     \n"
        "pld    pt1,0(%4)     \n"
        "pld    pt2,0(%5)     \n"

        "pcvt.w.s t4,pt0      \n"
        "pcvt.w.s t5,pt1      \n"
        "pcvt.w.s t6,pt2      \n"
        "sw       t4,0(%6)    \n"
        "sw       t5,0(%7)    \n"
        "sw       t6,0(%8)    \n"

        : "=rm" (d), "=rm" (e), "=rm" (f)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f)
        : "t4", "t5", "t6"
    );

    if (d == 658124288 && e == 196128704 && f == -589761024) {
        printf("PCVTWS test OK\n");
        return 0;
    }
    else {
        printf("PCVTWS test FAIL - Values: %lx %lx %lx %d %d %d\n", 
               a, b, c, d, e, f);
        return 1;
    }
}

int pcvtwus_test() {  // Pos to unsigned int
    int64_t a, b, c; 
    uint32_t d, e, f;

    a = 0x7FB87B7D0003F2E5;
    b = 0x7F6EC2BEFF7B4A24;
    c = 0x806E6C7AFFFCD520;
    d = 0;
    e = 0;
    f = 1;

    asm volatile (
        "pld    pt0,0(%3)     \n"
        "pld    pt1,0(%4)     \n"
        "pld    pt2,0(%5)     \n"

        "pcvt.wu.s t4,pt0     \n"
        "pcvt.wu.s t5,pt1     \n"
        "pcvt.wu.s t6,pt2     \n"
        "sw       t4,0(%6)    \n"
        "sw       t5,0(%7)    \n"
        "sw       t6,0(%8)    \n"

        : "=rm" (d), "=rm" (e), "=rm" (f)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f)
        : "t4", "t5", "t6"
    );

    if (d == 3285968896 && e == 196128704 && f == 0) {
        printf("PCVTWUS test OK\n");
        return 0;
    }
    else {
        printf("PCVTWUS test FAIL - Values: %lx %lx %lx %d %d %d\n", 
            a, b, c, d, e, f);
        return 1;
    }
}

int pcvtls_test() {  // Pos to long
    int64_t a, b, c, d;

    a = 0x7FC150300000FCB9;
    b = 0x803EAF55FFFFCD52;
    c = 0;
    d = 0;

    asm volatile (
        "pld    pt0,0(%2)     \n"
        "pld    pt1,0(%3)     \n"

        "pcvt.l.s t4,pt0      \n"
        "pcvt.l.s t5,pt1      \n"
        "sd       t4,0(%4)    \n"
        "sd       t5,0(%5)    \n"

        : "=rm" (c), "=rm" (d)
        : "r" (&a), "r" (&b), "r" (&c), "r" (&d)
        : "t4", "t5"
    );

    if (c == 5000003584 && d == -5001003008) {
        printf("PCVTLS test OK\n");
        return 0;
    }
    else {
        printf("PCVTLS test FAIL - Values: %lx %lx %ld %ld\n", 
               a, b, c, d);
        return 1;
    }
}

int pcvtlus_test() {  // Pos to unsigned long
    int64_t a, b, c;
    uint64_t d, e, f;

    a = 0x7FC150300000FCB9;
    b = 0x7FFFBE3F00000000;
    c = 0x803EAF55FFFFCD52;
    d = 0;
    e = 0;
    f = 1;

    asm volatile (
        "pld    pt0,0(%3)     \n"
        "pld    pt1,0(%4)     \n"
        "pld    pt2,0(%5)     \n"

        "pcvt.lu.s t4,pt0     \n"
        "pcvt.lu.s t5,pt1     \n"
        "pcvt.lu.s t6,pt2     \n"
        "sd        t4,0(%6)   \n"
        "sd        t5,0(%7)   \n"
        "sd        t6,0(%8)   \n"

        : "=rm" (d), "=rm" (e), "=rm" (f)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f)
        : "t4", "t5", "t6"
    );

    if (d == 5000003584 && e == 17435685957364875264ull && f == 0) {
        printf("PCVTLUS test OK\n");
        return 0;
    }
    else {
        printf("PCVTLUS test FAIL - Values: %lx %lx %lx %ld %ld %ld\n", 
            a, b, c, d, e, f);
        return 1;
    }
}

int pcvtsw_test() {  // Int to pos
    int32_t a, b, c;
    int64_t d, e, f;

    a = 658124290;  // Round -> 658124288 (Posit 0x7F939D1701000000)
    b = 196128700;  // Round -> 196128704 (Posit 0x7F6EC2BEF0000000)
    c = -589761023; // Round -> -589761024 (Posit 0x806E6C7B00800000)
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "lw       t0,0(%3)   \n"
        "lw       t1,0(%4)   \n"
        "lw       t2,0(%5)   \n"

        "pcvt.s.w pt4,t0     \n"
        "pcvt.s.w pt5,t1     \n"
        "pcvt.s.w pt6,t2     \n"
        "psd      pt4,0(%6)  \n"
        "psd      pt5,0(%7)  \n"
        "psd      pt6,0(%8)  \n"

        : "=rm" (d), "=rm" (e), "=rm" (f)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f)
        : "t0", "t1", "t2"
    );

    if (d == 0x7F939D1701000000 && e == 0x7F6EC2BEF0000000 && f == 0x806E6C7B00800000) {
        printf("PCVTSW test OK\n");
        return 0;
    }
    else {
        printf("PCVTSW test FAIL - Values: %x %x %x %lx %lx %lx\n", 
               a, b, c, d, e, f);
        return 1;
    }
}

int pcvtswu_test() {  // Unsigned int to pos
    uint32_t a, b, c;
    int64_t d, e, f;

    a = 3285968897; // Round -> 3285968897 (Posit 0x7FB87B7D00200000)
    b = 196128700;  // Round -> 196128700 (Posit 0x7F6EC2BEF0000000)
    c = 0;          // Round -> 0 (Posit 0x0000000000000000)
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "lw        t0,0(%3)   \n"
        "lw        t1,0(%4)   \n"
        "lw        t2,0(%5)   \n"

        "pcvt.s.wu pt4,t0     \n"
        "pcvt.s.wu pt5,t1     \n"
        "pcvt.s.wu pt6,t2     \n"
        "psd       pt4,0(%6)  \n"
        "psd       pt5,0(%7)  \n"
        "psd       pt6,0(%8)  \n"

        : "=rm" (d), "=rm" (e), "=rm" (f)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f)
        : "t0", "t1", "t2"
    );

    if (d == 0x7FB87B7D00200000 && e == 0x7F6EC2BEF0000000 && f == 0) {
        printf("PCVTSWU test OK\n");
        return 0;
    }
    else {
        printf("PCVTSWU test FAIL - Values: %x %x %x %lx %lx %lx\n", 
            a, b, c, d, e, f);
        return 1;
    }
}

int pcvtsl_test() {  // Long to pos
    int64_t a, b, c, d;

    a = 5000000000;  // Round -> 5000000000 (Posit 0x7FC1502F90000000)
    b = -5001000000; // Round -> -5001000000 (Posit 0x803EAF565E000000)
    c = 0;
    d = 0;

    asm volatile (
        "ld       t0,0(%2)     \n"
        "ld       t1,0(%3)     \n"

        "pcvt.s.l pt4,t0       \n"
        "pcvt.s.l pt5,t1       \n"
        "psd      pt4,0(%4)    \n"
        "psd      pt5,0(%5)    \n"

        : "=rm" (c), "=rm" (d)
        : "r" (&a), "r" (&b), "r" (&c), "r" (&d)
        : "t0", "t1"
    );

    if (c == 0x7FC1502F90000000 && d == 0x803EAF565E000000) {
        printf("PCVTSL test OK\n");
        return 0;
    }
    else {
        printf("PCVTSL test FAIL - Values: %lx %lx %lx %lx\n", a, b, c, d);
        return 1;
    }
}

int pcvtslu_test() {  // Unsigned long to pos
    uint64_t a, b, c;
    int64_t d, e, f;

    a = 5000000000;          // Round -> 5000000000 (Posit 0x7FC1502F90000000)
    b = 1743568595736487501; // Round -> 1.7435685957364613e+18 (Posit 0x7FFF883266666666)
    c = 0;                   // Round -> 0 (Posit 0x0000000000000000)
    d = 0;
    e = 0;
    f = 1;

    asm volatile (
        "ld       t0,0(%3)      \n"
        "ld       t1,0(%4)      \n"
        "ld       t2,0(%5)      \n"

        "pcvt.s.lu pt4,t0       \n"
        "pcvt.s.lu pt5,t1       \n"
        "pcvt.s.lu pt6,t2       \n"
        "psd      pt4,0(%6)     \n"
        "psd      pt5,0(%7)     \n"
        "psd      pt6,0(%8)     \n"

        : "=rm" (d), "=rm" (e), "=rm" (f)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f)
        : "t0", "t1", "t2"
    );

    if (d == 0x7FC1502F90000000 && e == 0x7FFF883266666666 && f == 0) {
        printf("PCVTSLU test OK\n");
        return 0;
    }
    else {
        printf("PCVTSLU test FAIL - Values: %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f);
        return 1;
    }
}

int psgnj_test() {
    int64_t a, b, c, d, e, f, g, h;

    a = 0x7FC150300000FCB9; // Posit  5000003584.1233997
    b = 0x7FFFBE3F00000000; // Posit  1.7435685957364875e+19
    c = 0x803EAF55FFFFCD52; // Posit -5001003008.0247459
    d = 0x802D1453C4EBC02B; // Posit -23451803018.124672
    e = 0;
    f = 0;
    g = 0;
    h = 0;

    asm volatile (
        "pld     pt0,0(%4)      \n"
        "pld     pt1,0(%5)      \n"
        "pld     pt2,0(%6)      \n"
        "pld     pt3,0(%7)      \n"

        "psgnj.s pt4,pt0,pt1    \n" 
        "psgnj.s pt5,pt0,pt2    \n" 
        "psd     pt4,0(%8)      \n"
        "psd     pt5,0(%9)      \n"
        "psgnj.s pt4,pt2,pt1    \n" 
        "psgnj.s pt5,pt2,pt3    \n" 
        "psd     pt4,0(%10)     \n"
        "psd     pt5,0(%11)     \n"

        : "=rm" (e), "=rm" (f), "=rm" (g), "=rm" (h)
        : "r" (&a), "r" (&b), "r" (&c), "r" (&d), 
          "r" (&e), "r" (&f), "r" (&g), "r" (&h)
        :
    );

    if (e == 0x7FC150300000FCB9 && f == 0x803EAFCFFFFF0347 
        && g == 0x7FC150AA000032AE && h == 0x803EAF55FFFFCD52) {
        printf("PSGNJ test OK\n");
        return 0;
    }
    else {
        printf("PSGNJ test FAIL - Values: %lx %lx %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f, g, h);
        return 1;
    }
}

int psgnjn_test() {
    int64_t a, b, c, d, e, f, g, h;

    a = 0x7FC150300000FCB9; // Posit  5000003584.1233997
    b = 0x7FFFBE3F00000000; // Posit  1.7435685957364875e+19
    c = 0x803EAF55FFFFCD52; // Posit -5001003008.0247459
    d = 0x802D1453C4EBC02B; // Posit -23451803018.124672
    e = 0;
    f = 0;
    g = 0;
    h = 0;

    asm volatile (
        "pld     pt0,0(%4)      \n"
        "pld     pt1,0(%5)      \n"
        "pld     pt2,0(%6)      \n"
        "pld     pt3,0(%7)      \n"

        "psgnjn.s pt4,pt0,pt1   \n" 
        "psgnjn.s pt5,pt0,pt2   \n" 
        "psd      pt4,0(%8)     \n"
        "psd      pt5,0(%9)     \n"
        "psgnjn.s pt4,pt2,pt1   \n" 
        "psgnjn.s pt5,pt2,pt3   \n" 
        "psd      pt4,0(%10)    \n"
        "psd      pt5,0(%11)    \n"

        : "=rm" (e), "=rm" (f), "=rm" (g), "=rm" (h)
        : "r" (&a), "r" (&b), "r" (&c), "r" (&d), 
          "r" (&e), "r" (&f), "r" (&g), "r" (&h)
        :
    );

    if (e == 0x803EAFCFFFFF0347 && f == 0x7FC150300000FCB9
        && g == 0x803EAF55FFFFCD52 && h == 0x7FC150AA000032AE) {
        printf("PSGNJN test OK\n");
        return 0;
    }
    else {
        printf("PSGNJN test FAIL - Values: %lx %lx %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f, g, h);
        return 1;
    }
}

int psgnjnx_test() {
    int64_t a, b, c, d, e, f, g, h;

    a = 0x7FC150300000FCB9; // Posit  5000003584.1233997
    b = 0x7FFFBE3F00000000; // Posit  1.7435685957364875e+19
    c = 0x803EAF55FFFFCD52; // Posit -5001003008.0247459
    d = 0x802D1453C4EBC02B; // Posit -23451803018.124672
    e = 0;
    f = 0;
    g = 0;
    h = 0;

    asm volatile (
        "pld     pt0,0(%4)      \n"
        "pld     pt1,0(%5)      \n"
        "pld     pt2,0(%6)      \n"
        "pld     pt3,0(%7)      \n"

        "psgnjx.s pt4,pt0,pt1   \n" 
        "psgnjx.s pt5,pt0,pt2   \n" 
        "psd      pt4,0(%8)     \n"
        "psd      pt5,0(%9)     \n"
        "psgnjx.s pt4,pt2,pt1   \n" 
        "psgnjx.s pt5,pt2,pt3   \n" 
        "psd      pt4,0(%10)    \n"
        "psd      pt5,0(%11)    \n"

        : "=rm" (e), "=rm" (f), "=rm" (g), "=rm" (h)
        : "r" (&a), "r" (&b), "r" (&c), "r" (&d), 
          "r" (&e), "r" (&f), "r" (&g), "r" (&h)
        :
    );

    if (e == 0x7FC150300000FCB9 && f == 0x803EAFCFFFFF0347 
        && g == 0x803EAF55FFFFCD52 && h == 0x7FC150AA000032AE) {
        printf("PSGNJNX test OK\n");
        return 0;
    }
    else {
        printf("PSGNJNX test FAIL - Values: %lx %lx %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f, g, h);
        return 1;
    }
}

int pmvxw_test() {  // Move pos to int reg
    int64_t a, b, c, d, e, f;

    a = 0x7FC150300000FCB9;
    b = 0x7FFFBE3F00000000;
    c = 0x802D1453C4EBC02B;
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "pld    pt0,0(%3)      \n"
        "pld    pt1,0(%4)      \n"
        "pld    pt2,0(%5)      \n"

        "pmv.x.w  t4,pt0       \n"
        "pmv.x.w  t5,pt1       \n"
        "pmv.x.w  t6,pt2       \n"
        "sd       t4,0(%6)     \n"
        "sd       t5,0(%7)     \n"
        "sd       t6,0(%8)     \n"

        : "=rm" (d), "=rm" (e), "=rm" (f)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f)
        : "t4", "t5", "t6"
    );

    if (d == 9205727280410721465 && e == 9223299739670282240 && 
        f == -9210683312884170709) {
        printf("PMVXW test OK\n");
        return 0;
    }
    else {
        printf("PMVXW test FAIL - Values: %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f);
        return 1;
    }
}

int pmvwx_test() {  // Move int to pos reg
    int64_t a, b, c, d, e, f;

    a = 9205727280410721465;
    b = 9223299739670282240;
    c = -9210683312884170709;
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "ld       t0,0(%3)     \n"
        "ld       t1,0(%4)     \n"
        "ld       t2,0(%5)     \n"

        "pmv.w.x  pt4,t0       \n"
        "pmv.w.x  pt5,t1       \n"
        "pmv.w.x  pt6,t2       \n"
        "psd      pt4,0(%6)    \n"
        "psd      pt5,0(%7)    \n"
        "psd      pt6,0(%8)    \n"

        : "=rm" (d), "=rm" (e), "=rm" (f)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f)
        : "t0", "t1", "t2"
    );

    if (d == 0x7FC150300000FCB9 && e == 0x7FFFBE3F00000000 && 
        f == 0x802D1453C4EBC02B) {
        printf("PMVWX test OK\n");
        return 0;
    }
    else {
        printf("PMVWX test FAIL - Values: %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f);
        return 1;
    }
}

int peq_test() {
    int64_t a, b, c, d, e, f;

    a = 0x7FFEF4E807159380; // Posit  65812428845678592
    b = 0x7FFB64C18B7AA480; // Posit  196128704123456
    c = 0x8001EC309E70B4B7; // Posit -5897610247459392
    d = 1;
    e = 0;
    f = 0;

    asm volatile (
        "pld    pt0,0(%3)      \n"
        "pld    pt1,0(%4)      \n"
        "pld    pt2,0(%5)      \n"

        "peq.s  t3,pt0,pt1    \n" 
        "peq.s  t4,pt1,pt1    \n" 
        "peq.s  t5,pt2,pt2    \n" 
        "sd     t3,0(%6)      \n"
        "sd     t4,0(%7)      \n"
        "sd     t5,0(%8)      \n"

        : "=rm" (d), "=rm" (e), "=rm" (f)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f)
        : "t3", "t4", "t5"
    );

    if (d == 0 && e == 1 && f == 1) {
        printf("PEQ test OK\n");
        return 0;
    }
    else {
        printf("PEQ test FAIL - Values: %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f);
        return 1;
    }
}

int plt_test() {
    int64_t a, b, c, d, e, f, g, h;

    a = 0x7FFEF4E807159380; // Posit  65812428845678592
    b = 0x7FFB64C18B7AA480; // Posit  196128704123456
    c = 0x8001EC309E70B4B7; // Posit -5897610247459392
    d = 1;
    e = 0;
    f = 0;
    g = 1;
    h = 1;

    asm volatile (
        "pld    pt0,0(%5)     \n"
        "pld    pt1,0(%6)     \n"
        "pld    pt2,0(%7)     \n"

        "plt.s  t3,pt0,pt1    \n" 
        "plt.s  t4,pt1,pt0    \n" 
        "plt.s  t5,pt2,pt0    \n" 
        "plt.s  t6,pt0,pt2    \n" 
        "sd     t3,0(%8)      \n"
        "sd     t4,0(%9)      \n"
        "sd     t5,0(%10)     \n"
        "sd     t6,0(%11)     \n"
        "plt.s  t6,pt2,pt2    \n" 
        "sd     t6,0(%12)     \n"

        : "=rm" (d), "=rm" (e), "=rm" (f), "=rm" (g), "=rm" (h)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f), "r" (&g), "r" (&h)
        : "t3", "t4", "t5", "t6"
    );

    if (d == 0 && e == 1 && f == 1 && g == 0 && h == 0) {
        printf("PLT test OK\n");
        return 0;
    }
    else {
        printf("PLT test FAIL - Values: %lx %lx %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f, g, h);
        return 1;
    }
}

int ple_test() {
    int64_t a, b, c, d, e, f, g;

    a = 0x7FFEF4E807159380; // Posit  65812428845678592
    b = 0x7FFB64C18B7AA480; // Posit  196128704123456
    c = 0x8001EC309E70B4B7; // Posit -5897610247459392
    d = 1;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "pld    pt0,0(%4)  \n"
        "pld    pt1,0(%5)  \n"
        "pld    pt2,0(%6)  \n"

        "ple.s  t3,pt0,pt1    \n" 
        "ple.s  t4,pt1,pt0    \n" 
        "ple.s  t5,pt2,pt0    \n" 
        "ple.s  t6,pt2,pt2    \n" 
        "sd     t3,0(%7)  \n"
        "sd     t4,0(%8)  \n"
        "sd     t5,0(%9)  \n"
        "sd     t6,0(%10)  \n"

        : "=rm" (d), "=rm" (e), "=rm" (f), "=rm" (g)
        : "r" (&a), "r" (&b), "r" (&c), 
          "r" (&d), "r" (&e), "r" (&f), "r" (&g)
        : "t3", "t4", "t5", "t6"
    );

    if (d == 0 && e == 1 && f == 1 && g == 1) {
        printf("PLE test OK\n");
        return 0;
    }
    else {
        printf("PLE test FAIL - Values: %lx %lx %lx %lx %lx %lx %lx\n", 
               a, b, c, d, e, f, g);
        return 1;
    }
}

int main() {

    padd_test();
    psub_test();
    pmul_test();
    pdiv_test();
    psqrt_test();
    pmin_test();
    pmax_test();

    quire_test();

    pcvtws_test();
    pcvtwus_test();
    pcvtls_test();
    pcvtlus_test();
    pcvtsw_test();
    pcvtswu_test();
    pcvtsl_test();
    pcvtslu_test();

    psgnj_test();
    psgnjn_test();
    psgnjnx_test();

    pmvxw_test();
    pmvwx_test();

    peq_test();
    plt_test();
    ple_test();

    return 0;
}
