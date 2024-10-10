pragma circom 2.0.0;
pragma custom_templates;

include "montgomery.circom";
include "mux3.circom";
include "babyjub.circom";

include "../../../node_modules/circomlib/circuits/gates.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

function nbits(a) {
    var n = 1;
    var r = 0;
    while (n-1<a) {
        r++;
        n *= 2;
    }
    return r;
}

template A(a, b, c) {}

template nbits(a) {
    var o_u_t;
    var o$o;
    var x[3] = [2,8,4];
    var z[n];  // where n is a parameter of a template
    var dbl[16][2] = base;

    lc1 - 1 === out + 1;

    var y[5] = someFunction(n);

    signal output out[2];
    signal intermediate[4];

    signal out <== 2;

    var e4 = 1 && 0;

    signal input in;
    signal output out[n];
    var lc1=0;
    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }
    component temp_a = A(n);
    out <== temp_a.c;
    lc1 === in;

    if(i < n){
    signal out <== 2;
    i = out;
   }
   outA <== i;

   log("Number: ", 100);

   for(var i=0; i<2; i++)for(var idx=0; idx<CHUNK_NUMBER; idx++){
        tmp[0][i][idx] <== add.out[i][idx] + addIsDouble * (doub.out[i][idx] - add.out[i][idx]);
        // if a = O, then a + b = b
        tmp[1][i][idx] <== tmp[0][i][idx] + aIsInfinity * (b[i][idx] - tmp[0][i][idx]);
        // if b = O, then a + b = a
        tmp[2][i][idx] <== tmp[1][i][idx] + bIsInfinity * (a[i][idx] - tmp[1][i][idx]);
        out[i][idx] <== tmp[2][i][idx] + isInfinity * (a[i][idx] - tmp[2][i][idx]);
   }

   component commitmentHash = Poseidon(2);
   (commitmentHash.inputs[0], commitmentHash.inputs[1]) <== (nullifier, secret);
}

component main {public [in1]}= A();

// Some comment