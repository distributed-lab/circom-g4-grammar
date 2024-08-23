pragma circom 2.0.0;

function someFunc(a) {
    var (k1, k2) = (1, 2);

    (k1, k2) = (3, 2);

    return 2;
}

template B(a) {
    signal input b;
    signal output c;

    var (k1, k2) = (1, 2);

    k2 = someFunc(a);

    k2++;

    (k1, k2) = (1, 2);

    c <== a + b;
}

template parallel A(a1) {
    signal output {a} a;

    signal input b;
    signal input c;

    component aliasCheck = parallel B(a1);
    aliasCheck.b <== b;

    a <== b * c;
}

component main {public[b]} = A(2);