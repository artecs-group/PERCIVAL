#include <stdio.h>
#include <stdint.h>

int padd_test() {
    int32_t a, b, c, d, e, f, g;

    a = 0x7F939D17; // Posit  658124288
    b = 0x7F6EC2BF; // Posit  196128704
    c = 0x806E6C7B; // Posit -589761024
    d = 0;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "plw	pt0,-24(s0)  \n"
        "plw	pt1,-28(s0)  \n"
        "plw	pt2,-32(s0)  \n"

        "padd.s	pt3,pt0,pt1    \n"
        "padd.s	pt4,pt1,pt0    \n"
        "psw	pt3,-36(s0)  \n"
        "psw	pt4,-40(s0)  \n"

        "padd.s	pt5,pt2,pt1    \n"
        "padd.s	pt6,pt0,pt2    \n"
        "psw	pt5,-44(s0)  \n"
        "psw	pt6,-48(s0)  \n"
    );

    if (d == 0x7F99756F && e == 0x7F99756F && f == 0x807889A6 && g == 0x7F409920) {
        printf("PADD test OK\n");
        return 0;
    }
    else {
        printf("PADD test FAIL - Values: %x %x %x %x %x %x %x\n", a, b, c, d, e, f, g);
        return 1;
    }
}

int psub_test() {
    int32_t a, b, c, d, e, f, g;

    a = 0x7F939D17; // Posit  658124288
    b = 0x7F6EC2BF; // Posit  196128704
    c = 0x806E6C7B; // Posit -589761024
    d = 0;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "plw	pt0,-24(s0)  \n"
        "plw	pt1,-28(s0)  \n"
        "plw	pt2,-32(s0)  \n"

        "psub.s	pt3,pt0,pt1    \n" //7f8b987e
        "psub.s	pt4,pt1,pt0    \n" //80747682
        "psw	pt3,-36(s0)  \n"
        "psw	pt4,-40(s0)  \n"

        "psub.s	pt5,pt2,pt1    \n" //80689423
        "psub.s	pt6,pt0,pt2    \n" //7fa2984e
        "psw	pt5,-44(s0)  \n"
        "psw	pt6,-48(s0)  \n"
    );

    if (d == 0x7F8B897E && e == 0x80747682 && f == 0x80689423 && g == 0x7FA2984E) {
        printf("PSUB test OK\n");
        return 0;
    }
    else {
        printf("PSUB test FAIL - Values: %x %x %x %x %x %x %x\n", a, b, c, d, e, f, g);
        return 1;
    }
}

int pmul_test() {
    int32_t a, b, c, d, e, f, g;

    a = 0x6F10A532; // Posit  226.08066177368164
    b = 0x7B9B7665; // Posit  52667.197265625
    c = 0x87E89FBC; // Posit -4470.0166015625
    d = 0;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "plw	pt0,-24(s0)  \n"
        "plw	pt1,-28(s0)  \n"
        "plw	pt2,-32(s0)  \n"

        "pmul.s	pt3,pt0,pt1    \n"
        "pmul.s	pt4,pt1,pt0    \n"
        "psw	pt3,-36(s0)  \n"
        "psw	pt4,-40(s0)  \n"

        "pmul.s	pt5,pt2,pt1    \n"
        "pmul.s	pt6,pt0,pt2    \n"
        "psw	pt5,-44(s0)  \n"
        "psw	pt6,-48(s0)  \n"
    );

    if (d == 0x7EDAD7ED && e == 0x7EDAD7ED && f == 0x8087DEE8 && g == 0x8209467B) {
        printf("PMUL test OK\n");
        return 0;
    }
    else {
        printf("PMUL test FAIL - Values: %x %x %x %x %x %x %x\n", a, b, c, d, e, f, g);
        return 1;
    }
}

int pdiv_test() {
    int32_t a, b, c, d, e, f, g, h, zero;

    a = 0x6F10A532; // Posit  226.08066177368164
    b = 0x7B9B7665; // Posit  52667.197265625
    c = 0x87E89FBC; // Posit -4470.0166015625
    d = 0;
    e = 0;
    f = 0;
    g = 0;
    h = 1;
    zero = 0;

    asm volatile (
        "plw    pt0,-24(s0)  \n"
        "plw    pt1,-28(s0)  \n"
        "plw    pt2,-32(s0)  \n"

        "pdiv.s pt3,pt0,pt1    \n" // 0.004292628 -> 10654963
        "pdiv.s pt4,pt1,pt0    \n" // 232.957550869 -> 6F47A910
        "psw    pt3,-36(s0)  \n"
        "psw    pt4,-40(s0)  \n"

        "pdiv.s pt3,pt2,pt1    \n" // -0.084872878 -> DD22E2B2
        "pdiv.s pt4,pt0,pt2    \n" // -0.050577141 -> E186B031
        "plw    pt6,-56(s0)  \n"
        "pdiv.s pt5,pt0,pt6    \n" // Division by zero
        "psw    pt3,-44(s0)  \n"
        "psw    pt4,-48(s0)  \n"
        "psw    pt5,-52(s0)  \n"
    );

    // Logarithmic approximate division
    if (d == 0x10A2CB9E && e == 0x6F5D3462 && f == 0xDC20B108 && g == 0xE14CDBDE && h == 0x80000000) {
        printf("PDIV test OK\n");
        return 0;
    }
    else {
        printf("PDIV test FAIL - Values: %x %x %x %x %x %x %x %x\n", a, b, c, d, e, f, g, h);
        return 1;
    }
}

int psqrt_test() {
    int32_t a, b, c, d, e, f;

    a = 0x6F10A532; // Posit  226.08066177368164
    b = 0x7B9B7665; // Posit  52667.197265625
    c = 0x87E89FBC; // Posit -4470.0166015625
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "plw    pt0,-24(s0)  \n"
        "plw    pt1,-28(s0)  \n"
        "plw    pt2,-32(s0)  \n"

        "psqrt.s pt3,pt0      \n" // 15.03597891 -> 5F0935EA
        "psqrt.s pt4,pt1      \n" // 229.493349066 -> 6F2BF261
        "psqrt.s pt5,pt2      \n" // NaR -> 80000000
        "psw    pt3,-36(s0)  \n"
        "psw    pt4,-40(s0)  \n"
        "psw    pt5,-44(s0)  \n"
    );

    // Logarithmic approximate sqrt
    if (d == 0x5F10A532 && e == 0x6F36ECCA && f == 0x80000000) {
        printf("PSQRT test OK\n");
        return 0;
    }
    else {
        printf("PSQRT test FAIL - Values: %x %x %x %x %x %x\n", a, b, c, d, e, f);
        return 1;
    }
}

int pmin_test() {
    int32_t a, b, c, d, e, f, g;

    a = 0x7F939D17; // Posit  658124288
    b = 0x7F6EC2BF; // Posit  196128704
    c = 0x806E6C7B; // Posit -589761024
    d = 0;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "plw	pt0,-24(s0)  \n"
        "plw	pt1,-28(s0)  \n"
        "plw	pt2,-32(s0)  \n"

        "pmin.s pt3,pt0,pt1    \n" 
        "pmin.s pt4,pt1,pt0    \n" 
        "pmin.s pt5,pt2,pt0    \n" 
        "pmin.s pt6,pt2,pt2    \n" 
        "psw    pt3,-36(s0)  \n"
        "psw    pt4,-40(s0)  \n"
        "psw    pt5,-44(s0)  \n"
        "psw    pt6,-48(s0)  \n"
    );

    if (d == 0x7F6EC2BF && e == 0x7F6EC2BF && f == 0x806E6C7B && g == 0x806E6C7B) {
        printf("PMIN test OK\n");
        return 0;
    }
    else {
        printf("PMIN test FAIL - Values: %x %x %x %x %x %x %x\n", a, b, c, d, e, f, g);
        return 1;
    }
}

int pmax_test() {
    int32_t a, b, c, d, e, f, g;

    a = 0x7F939D17; // Posit  658124288
    b = 0x7F6EC2BF; // Posit  196128704
    c = 0x806E6C7B; // Posit -589761024
    d = 0;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "plw	pt0,-24(s0)  \n"
        "plw	pt1,-28(s0)  \n"
        "plw	pt2,-32(s0)  \n"

        "pmax.s pt3,pt0,pt1    \n" 
        "pmax.s pt4,pt1,pt0    \n" 
        "pmax.s pt5,pt2,pt0    \n" 
        "pmax.s pt6,pt2,pt2    \n" 
        "psw    pt3,-36(s0)  \n"
        "psw    pt4,-40(s0)  \n"
        "psw    pt5,-44(s0)  \n"
        "psw    pt6,-48(s0)  \n"
    );

    if (d == 0x7F939D17 && e == 0x7F939D17 && f == 0x7F939D17 && g == 0x806E6C7B) {
        printf("PMAX test OK\n");
        return 0;
    }
    else {
        printf("PMAX test FAIL - Values: %x %x %x %x %x %x %x\n", a, b, c, d, e, f, g);
        return 1;
    }
}

int quire_test() {
    int32_t a, b, c, d, e, f;

    a = 0x40000000; // Posit 1
    b = 0x40000000; // Posit 1
    c = 0x4C000000; // Posit 3
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "plw      pt3,-24(s0)  \n"
        "plw      pt4,-28(s0)  \n"
        "plw      pt5,-32(s0)  \n"

        "qclr.s               \n"    // Quire: 0
        "qmadd.s  pt3,pt4       \n"  // Quire: 1
        "qmadd.s  pt5,pt5       \n"  // Quire: 10
        "qmsub.s  pt4,pt5       \n"  // Quire: 7
        "qround.s pt6          \n"
        "psw      pt6,-36(s0)  \n"
        "qneg.s               \n"    // Quire: -7
        "qround.s pt6          \n"
        "psw      pt6,-40(s0)  \n"
        "qclr.s               \n"    // Quire: 0
        "qround.s pt6          \n"
        "psw      pt6,-44(s0)  \n"
    );

    if (d == 0x56000000 && e == 0xAA000000 && f == 0x00000000) {
        printf("QUIRE test OK\n");
        return 0;
    }
    else {
        printf("QUIRE test FAIL - Values: %x %x %x %x %x %x\n", a, b, c, d, e, f);
        return 1;
    }
}

int pcvtws_test() {  // Pos to int
    int32_t a, b, c, d, e, f;

    a = 0x7F939D17;
    b = 0x7F6EC2BF;
    c = 0x806E6C7B;
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "plw      pt0,-24(s0)  \n"
        "plw      pt1,-28(s0)  \n"
        "plw      pt2,-32(s0)  \n"

        "pcvt.w.s t4,pt0       \n"
        "pcvt.w.s t5,pt1       \n"
        "pcvt.w.s t6,pt2       \n"
        "sw       t4,-36(s0)  \n"
        "sw       t5,-40(s0)  \n"
        "sw       t6,-44(s0)  \n"
    );

    if (d == 658124288 && e == 196128704 && f == -589761024) {
        printf("PCVTWS test OK\n");
        return 0;
    }
    else {
        printf("PCVTWS test FAIL - Values: %x %x %x %x %x %x\n", a, b, c, d, e, f);
        return 1;
    }
}

int pcvtwus_test() {  // Pos to unsigned int
    int32_t a, b, c; 
    uint32_t d, e, f;

    a = 0x7FB87B7D;
    b = 0x7F6EC2BF;
    c = 0x806E6C7B;
    d = 0;
    e = 0;
    f = 1;

    asm volatile (
        "plw      pt0,-24(s0)  \n"
        "plw      pt1,-28(s0)  \n"
        "plw      pt2,-32(s0)  \n"

        "pcvt.wu.s t4,pt0       \n"
        "pcvt.wu.s t5,pt1       \n"
        "pcvt.wu.s t6,pt2       \n"
        "sw       t4,-36(s0)  \n"
        "sw       t5,-40(s0)  \n"
        "sw       t6,-44(s0)  \n"
    );

    if (d == 3285968896 && e == 196128704 && f == 0) {
        printf("PCVTWUS test OK\n");
        return 0;
    }
    else {
        printf("PCVTWUS test FAIL - Values: %x %x %x %x %x %x\n", a, b, c, d, e, f);
        return 1;
    }
}

int pcvtls_test() {  // Pos to long
    int32_t a, b;
    int64_t c, d;

    a = 0x7FC15030;
    b = 0x803EAF56;
    c = 0;
    d = 0;

    asm volatile (
        "plw      pt0,-24(s0)  \n"
        "plw      pt1,-28(s0)  \n"

        "pcvt.l.s t4,pt0       \n"
        "pcvt.l.s t5,pt1       \n"
        "sd       t4,-40(s0)  \n"
        "sd       t5,-48(s0)  \n"
    );

    if (c == 5000003584 && d == -5001003008) {
        printf("PCVTLS test OK\n");
        return 0;
    }
    else {
        printf("PCVTLS test FAIL - Values: %x %x %lx %lx\n", a, b, c, d);
        return 1;
    }
}

int pcvtlus_test() {  // Pos to unsigned long
    int32_t a, b, c;
    uint64_t d, e, f;

    a = 0x7FC15030;
    b = 0x7FFFBE3F;
    c = 0x803EAF56;
    d = 0;
    e = 0;
    f = 1;

    asm volatile (
        "plw      pt0,-24(s0)  \n"
        "plw      pt1,-28(s0)  \n"
        "plw      pt2,-32(s0)  \n"

        "pcvt.lu.s t4,pt0       \n"
        "pcvt.lu.s t5,pt1       \n"
        "pcvt.lu.s t6,pt2       \n"
        "sd       t4,-40(s0)  \n"
        "sd       t5,-48(s0)  \n"
        "sd       t6,-56(s0)  \n"
    );

    if (d == 5000003584 && e == 17435685957364875264ull && f == 0) {
        printf("PCVTLUS test OK\n");
        return 0;
    }
    else {
        printf("PCVTLUS test FAIL - Values: %x %x %x %lx %lx %lx\n", a, b, c, d, e, f);
        return 1;
    }
}

int pcvtsw_test() {  // Int to pos
    int32_t a, b, c, d, e, f;

    a = 658124290;  // Round -> 658124288 (Posit 0x7F939D17)
    b = 196128700;  // Round -> 196128704 (Posit 0x7F6EC2BF)
    c = -589761023; // Round -> -589761024 (Posit 0x806E6C7B)
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "lw       t0,-24(s0)  \n"
        "lw       t1,-28(s0)  \n"
        "lw       t2,-32(s0)  \n"

        "pcvt.s.w pt4,t0       \n"
        "pcvt.s.w pt5,t1       \n"
        "pcvt.s.w pt6,t2       \n"
        "psw      pt4,-36(s0)  \n"
        "psw      pt5,-40(s0)  \n"
        "psw      pt6,-44(s0)  \n"
    );

    if (d == 0x7F939D17 && e == 0x7F6EC2BF && f == 0x806E6C7B) {
        printf("PCVTSW test OK\n");
        return 0;
    }
    else {
        printf("PCVTSW test FAIL - Values: %x %x %x %x %x %x\n", a, b, c, d, e, f);
        return 1;
    }
}

int pcvtswu_test() {  // Unsigned int to pos
    uint32_t a, b, c;
    int32_t d, e, f;

    a = 3285968897; // Round -> 3285968896 (Posit 0x7FB87B7D)
    b = 196128700;  // Round -> 196128704 (Posit 0x7F6EC2BF)
    c = 0;          // Round -> 0 (Posit 0x00000000)
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "lw        t0,-24(s0)  \n"
        "lw        t1,-28(s0)  \n"
        "lw        t2,-32(s0)  \n"

        "pcvt.s.wu pt4,t0       \n"
        "pcvt.s.wu pt5,t1       \n"
        "pcvt.s.wu pt6,t2       \n"
        "psw       pt4,-36(s0)  \n"
        "psw       pt5,-40(s0)  \n"
        "psw       pt6,-44(s0)  \n"
    );

    if (d == 0x7FB87B7D && e == 0x7F6EC2BF && f == 0) {
        printf("PCVTSWU test OK\n");
        return 0;
    }
    else {
        printf("PCVTSWU test FAIL - Values: %x %x %x %x %x %x\n", a, b, c, d, e, f);
        return 1;
    }
}

int pcvtsl_test() {  // Long to pos
    int64_t a, b;
    int32_t c, d;

    a = 5000000000;  // Round -> 5000003584 (Posit 0x7FC15030)
    b = -5001000000; // Round -> -5001003008 (Posit 0x803EAF56)
    c = 0;
    d = 0;

    asm volatile (
        "ld       t0,-32(s0)  \n"
        "ld       t1,-40(s0)  \n"

        "pcvt.s.l pt4,t0       \n"
        "pcvt.s.l pt5,t1       \n"
        "psw      pt4,-44(s0)  \n"
        "psw      pt5,-48(s0)  \n"
    );

    if (c == 0x7FC15030 && d == 0x803EAF56) {
        printf("PCVTSL test OK\n");
        return 0;
    }
    else {
        printf("PCVTSL test FAIL - Values: %lx %lx %x %x\n", a, b, c, d);
        return 1;
    }
}

int pcvtslu_test() {  // Unsigned long to pos
    uint64_t a, b, c;
    int32_t d, e, f;

    a = 5000000000;              // Round -> 5000003584 (Posit 0x7FC15030)
    b = 17435685957364875013ull; // Round -> 17435685957364875264 (Posit 0x7FFFBE3F)
    c = 0;                       // Round -> 0 (Posit 0x00000000)
    d = 0;
    e = 0;
    f = 1;

    asm volatile (
        "ld       t0,-32(s0)  \n"
        "ld       t1,-40(s0)  \n"
        "ld       t2,-48(s0)  \n"

        "pcvt.s.lu pt4,t0       \n"
        "pcvt.s.lu pt5,t1       \n"
        "pcvt.s.lu pt6,t2       \n"
        "psw      pt4,-52(s0)  \n"
        "psw      pt5,-56(s0)  \n"
        "psw      pt6,-60(s0)  \n"
    );

    if (d == 0x7FC15030 && e == 0x7FFFBE3F && f == 0) {
        printf("PCVTSLU test OK\n");
        return 0;
    }
    else {
        printf("PCVTSLU test FAIL - Values: %lx %lx %lx %x %x %x\n", a, b, c, d, e, f);
        return 1;
    }
}

int psgnj_test() {
    int32_t a, b, c, d, e, f, g, h;

    a = 0x7F939D17; // Posit  658124288
    b = 0x7F6EC2BF; // Posit  196128704
    c = 0x806E6C7B; // Posit -589761024
    d = 0x8075C9C2; // Posit -439762432
    e = 0;
    f = 0;
    g = 0;
    h = 0;

    asm volatile (
        "plw     pt0,-24(s0)  \n"
        "plw     pt1,-28(s0)  \n"
        "plw     pt2,-32(s0)  \n"
        "plw     pt3,-36(s0)  \n"

        "psgnj.s pt4,pt0,pt1    \n" 
        "psgnj.s pt5,pt0,pt2    \n" 
        "psw     pt4,-40(s0)  \n"
        "psw     pt5,-44(s0)  \n"
        "psgnj.s pt4,pt2,pt1    \n" 
        "psgnj.s pt5,pt2,pt3    \n" 
        "psw     pt4,-48(s0)  \n"
        "psw     pt5,-52(s0)  \n"
    );

    if (e == 0x7F939D17 && f == 0x806C62E9 && g == 0x7F919385 && h == 0x806E6C7B) {
        printf("PSGNJ test OK\n");
        return 0;
    }
    else {
        printf("PSGNJ test FAIL - Values: %x %x %x %x %x %x %x %x\n", a, b, c, d, e, f, g, h);
        return 1;
    }
}

int psgnjn_test() {
    int32_t a, b, c, d, e, f, g, h;

    a = 0x7F939D17; // Posit  658124288
    b = 0x7F6EC2BF; // Posit  196128704
    c = 0x806E6C7B; // Posit -589761024
    d = 0x8075C9C2; // Posit -439762432
    e = 0;
    f = 0;
    g = 0;
    h = 0;

    asm volatile (
        "plw     pt0,-24(s0)  \n"
        "plw     pt1,-28(s0)  \n"
        "plw     pt2,-32(s0)  \n"
        "plw     pt3,-36(s0)  \n"

        "psgnjn.s pt4,pt0,pt1   \n" 
        "psgnjn.s pt5,pt0,pt2   \n" 
        "psw     pt4,-40(s0)  \n"
        "psw     pt5,-44(s0)  \n"
        "psgnjn.s pt4,pt2,pt1   \n" 
        "psgnjn.s pt5,pt2,pt3   \n" 
        "psw     pt4,-48(s0)  \n"
        "psw     pt5,-52(s0)  \n"
    );

    if (e == 0x806C62E9 && f == 0x7F939D17 && g == 0x806E6C7B && h == 0x7F919385) {
        printf("PSGNJN test OK\n");
        return 0;
    }
    else {
        printf("PSGNJN test FAIL - Values: %x %x %x %x %x %x %x %x\n", a, b, c, d, e, f, g, h);
        return 1;
    }
}

int psgnjnx_test() {
    int32_t a, b, c, d, e, f, g, h;

    a = 0x7F939D17; // Posit  658124288
    b = 0x7F6EC2BF; // Posit  196128704
    c = 0x806E6C7B; // Posit -589761024
    d = 0x8075C9C2; // Posit -439762432
    e = 0;
    f = 0;
    g = 0;
    h = 0;

    asm volatile (
        "plw     pt0,-24(s0)  \n"
        "plw     pt1,-28(s0)  \n"
        "plw     pt2,-32(s0)  \n"
        "plw     pt3,-36(s0)  \n"

        "psgnjx.s pt4,pt0,pt1   \n" 
        "psgnjx.s pt5,pt0,pt2   \n" 
        "psw     pt4,-40(s0)  \n"
        "psw     pt5,-44(s0)  \n"
        "psgnjx.s pt4,pt2,pt1   \n" 
        "psgnjx.s pt5,pt2,pt3   \n" 
        "psw     pt4,-48(s0)  \n"
        "psw     pt5,-52(s0)  \n"
    );

    if (e == 0x7F939D17 && f == 0x806C62E9 && g == 0x806E6C7B && h == 0x7F919385) {
        printf("PSGNJNX test OK\n");
        return 0;
    }
    else {
        printf("PSGNJNX test FAIL - Values: %x %x %x %x %x %x %x %x\n", a, b, c, d, e, f, g, h);
        return 1;
    }
}

int pmvxw_test() {  // Move pos to int reg
    int32_t a, b, c, d, e, f;

    a = 0x7F939D17;
    b = 0x7F6EC2BF;
    c = 0x806E6C7B;
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "plw      pt0,-24(s0)  \n"
        "plw      pt1,-28(s0)  \n"
        "plw      pt2,-32(s0)  \n"

        "pmv.x.w  t4,pt0       \n"
        "pmv.x.w  t5,pt1       \n"
        "pmv.x.w  t6,pt2       \n"
        "sw       t4,-36(s0)   \n"
        "sw       t5,-40(s0)   \n"
        "sw       t6,-44(s0)   \n"
    );

    if (d == 2140380439 && e == 2137965247 && f == -2140246917) {
        printf("PMVXW test OK\n");
        return 0;
    }
    else {
        printf("PMVXW test FAIL - Values: %x %x %x %x %x %x\n", a, b, c, d, e, f);
        return 1;
    }
}

int pmvwx_test() {  // Move int to pos reg
    int32_t a, b, c, d, e, f;

    a = 658124290;
    b = 196128700;
    c = -589761023;
    d = 0;
    e = 0;
    f = 0;

    asm volatile (
        "lw       t0,-24(s0)  \n"
        "lw       t1,-28(s0)  \n"
        "lw       t2,-32(s0)  \n"

        "pmv.w.x  pt4,t0       \n"
        "pmv.w.x  pt5,t1       \n"
        "pmv.w.x  pt6,t2       \n"
        "psw      pt4,-36(s0)  \n"
        "psw      pt5,-40(s0)  \n"
        "psw      pt6,-44(s0)  \n"
    );

    if (d == 0x273A2E02 && e == 0x0BB0AFBC && f == 0xDCD8F601) {
        printf("PMVWX test OK\n");
        return 0;
    }
    else {
        printf("PMVWX test FAIL - Values: %x %x %x %x %x %x\n", a, b, c, d, e, f);
        return 1;
    }
}

int peq_test() {
    int32_t a, b, c, d, e, f;

    a = 0x7F939D17; // Posit  658124288
    b = 0x7F6EC2BF; // Posit  196128704
    c = 0x806E6C7B; // Posit -589761024
    d = 1;
    e = 0;
    f = 0;

    asm volatile (
        "plw    pt0,-24(s0)  \n"
        "plw    pt1,-28(s0)  \n"
        "plw    pt2,-32(s0)  \n"

        "peq.s  t3,pt0,pt1    \n" 
        "peq.s  t4,pt1,pt1    \n" 
        "peq.s  t5,pt2,pt2    \n" 
        "sw     t3,-36(s0)  \n"
        "sw     t4,-40(s0)  \n"
        "sw     t5,-44(s0)  \n"
    );

    if (d == 0 && e == 1 && f == 1) {
        printf("PEQ test OK\n");
        return 0;
    }
    else {
        printf("PEQ test FAIL - Values: %x %x %x %x %x %x\n", a, b, c, d, e, f);
        return 1;
    }
}

int plt_test() {
    int32_t a, b, c, d, e, f, g, h;

    a = 0x7F939D17; // Posit  658124288
    b = 0x7F6EC2BF; // Posit  196128704
    c = 0x806E6C7B; // Posit -589761024
    d = 1;
    e = 0;
    f = 0;
    g = 1;
    h = 1;

    asm volatile (
        "plw    pt0,-24(s0)  \n"
        "plw    pt1,-28(s0)  \n"
        "plw    pt2,-32(s0)  \n"

        "plt.s  t3,pt0,pt1    \n" 
        "plt.s  t4,pt1,pt0    \n" 
        "plt.s  t5,pt2,pt0    \n" 
        "plt.s  t6,pt0,pt2    \n" 
        "sw     t3,-36(s0)  \n"
        "sw     t4,-40(s0)  \n"
        "sw     t5,-44(s0)  \n"
        "sw     t6,-48(s0)  \n"
        "plt.s  t6,pt2,pt2    \n" 
        "sw     t6,-52(s0)  \n"
    );

    if (d == 0 && e == 1 && f == 1 && g == 0 && h == 0) {
        printf("PLT test OK\n");
        return 0;
    }
    else {
        printf("PLT test FAIL - Values: %x %x %x %x %x %x %x %x\n", a, b, c, d, e, f, g, h);
        return 1;
    }
}

int ple_test() {
    int32_t a, b, c, d, e, f, g;

    a = 0x7F939D17; // Posit  658124288
    b = 0x7F6EC2BF; // Posit  196128704
    c = 0x806E6C7B; // Posit -589761024
    d = 1;
    e = 0;
    f = 0;
    g = 0;

    asm volatile (
        "plw    pt0,-24(s0)  \n"
        "plw    pt1,-28(s0)  \n"
        "plw    pt2,-32(s0)  \n"

        "ple.s  t3,pt0,pt1    \n" 
        "ple.s  t4,pt1,pt0    \n" 
        "ple.s  t5,pt2,pt0    \n" 
        "ple.s  t6,pt2,pt2    \n" 
        "sw     t3,-36(s0)  \n"
        "sw     t4,-40(s0)  \n"
        "sw     t5,-44(s0)  \n"
        "sw     t6,-48(s0)  \n"
    );

    if (d == 0 && e == 1 && f == 1 && g == 1) {
        printf("PLE test OK\n");
        return 0;
    }
    else {
        printf("PLE test FAIL - Values: %x %x %x %x %x %x %x\n", a, b, c, d, e, f, g);
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
