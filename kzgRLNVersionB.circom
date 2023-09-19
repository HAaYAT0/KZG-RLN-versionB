pragma circom 2.1.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "./utils.circom";

// num2Bits from circomlib-bitify.circom


template RLNProof(DEPTH, MAX_ORDER) {
    signal private input polynomialCoefficients[MAX_ORDER]; 
    signal private input privateKey;
    
    signal input n; // order of polynomial
    signal input commitment[2];
    signal input identityPathIndex[DEPTH]; 
    signal input pathElements[DEPTH];
    signal input root; // Merkle Treeのroot
    

    // component num2Bits = Num2Bits(); // (1)How should I set the length of the bit sequence as an argument for num2Bits?


    // repeated squaring algorithm

    // I try to conpute [g^Co, g^(α*C1), ..., g^((α^n)*Cn)] 
    // first, I convert the polynomialCoefficients to Binary numbers
    // then, I use Binary numbers to reduce the number of multiplication
    // var eachOpenCommitment[n];
    // var num2BitsPolynomialCoefficients[n];
    // for(var i = 0; i <= n; i++) {
    //     num2Bits.in <== polynomialCoefficients[i];
    //     num2BitsPolynomialCoefficients[i] <== num2Bits.out;

    //     var squaredSRS[num2BitsPolynomialCoefficients.length][2]; 
    //     for(var i = 0; i < num2BitsPolynomialCoefficients.length; i++) {
    //         // now I'm stuck
    //         squaredSRS[i][0] <== srs[i][0]
    //         squaredSRS[i][1] <== srs[i][1] 
    //     }
        
    // } 
    // By multiplying each term of eachOpenCommitment(using the paring library), comupte g^f(α)


    // constraints
    // pk=f(0)=C0
    privateKey === polynomialCoefficients[0];

    // membership proof of g^f(0)
    var preliminaryRateCommitment <== Poseidon(2)([polynomialCoefficients[0]], n);
    root <== MerkleTreeInclusionProof(DEPTH)(preliminaryRateCommitment, identityPathIndex, pathElements);

    
    // Ci=0 when i >= n+1
    for (var i = n+1; i < MAX_ORDER; i++) {
        polynomialCoefficients[i] <== 0;
    }
}
