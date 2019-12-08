# Decision Variables
var b1 binary;
var b2 binary;
var b3 binary;
var b4 binary;
var b5 binary;
var b6 binary;

var b11 binary;
var b12 binary;
var b13 binary;
var b14 binary;
var b15 binary;
var b16 binary;
var b17 binary;
var b18 binary;
var b19 binary;
var b110 binary;


var b21 binary;
var b22 binary;
var b23 binary;
var b24 binary;
var b25 binary;
var b26 binary;
var b27 binary;
var b28 binary;
var b29 binary;
var b210 binary;


var b31 binary;
var b32 binary;
var b33 binary;
var b34 binary;
var b35 binary;
var b36 binary;
var b37 binary;
var b38 binary;
var b39 binary;
var b310 binary;


var b41 binary;
var b42 binary;
var b43 binary;
var b44 binary;
var b45 binary;
var b46 binary;
var b47 binary;
var b48 binary;
var b49 binary;
var b410 binary;

var b51 binary;
var b52 binary;
var b53 binary;
var b54 binary;
var b55 binary;
var b56 binary;
var b57 binary;
var b58 binary;
var b59 binary;
var b510 binary;

var b61 binary;
var b62 binary;
var b63 binary;
var b64 binary;
var b65 binary;
var b66 binary;
var b67 binary;
var b68 binary;
var b69 binary;
var b610 binary;

# Objective Function
minimize Total: 30*b1 + 36*b2 + 21*b3 + 25*b4 + 20*b5 + 40*b6

+ 10 * b1 * b11 + 5 * b1 * b12 + 40 * b1 * b13 + 25 * b1 * b14 + 35 * b1 * b15 
+ 5 * b1 * b16 + 20 * b1 * b17 + 30 * b1 * b18 + 25 * b1 * b19 + 45 * b1 * b110

+ 20 * b2 * b21 + 45 * b2 * b22 + 20 * b2 * b23 + 15 * b2 * b24 + 45 * b2 * b25
+ 20 * b2 * b26  + 20 * b2 * b27 + 10 * b2 * b28 + 35 * b2 * b29 + 10 * b2 * b210

+ 25 * b3 * b31 + 40 * b3 * b32 + 35 * b3 * b33 + 30 * b3 * b34  + 35 * b3 * b35
+ 45 * b3 * b36 + 15 * b3 * b37 +  50 * b3 * b38 +  20 * b3 * b39  + 25 * b3 * b310

+ 15 * b4 * b41 + 25 * b4 * b42 + 35 * b4 * b43 + 45 * b4 * b44 + 35 * b4 * b45
+ 30 * b4 * b46 +  30 * b4 * b47 + 25 * b4 * b48 + 20 * b4 * b49 + 20 * b4 * b410

+ 40 * b5 * b51 +  35 * b5 * b52 + 15 * b5 * b53 + 30 * b5 * b54 + 40 * b5 * b55
+ 25 * b5 * b56  +  35 * b5 * b57 +  20 * b5 * b58 + 40 * b5 * b59 + 35 * b5 * b510

+ 15 * b6 * b61 + 30 * b6 * b62 + 20 * b6 * b63 +  25 * b6 * b64 + 15 * b6 * b65
+ 35 * b6 * b66 +  10 * b6 * b67 + 45 * b6 * b68 + 35 * b6 * b69 +  25 * b6 * b610;

# Constraints
s.t. M1: b1 * b11 + b2 * b21 + b3 * b31 + b4 * b41 + b5 * b51 + b6 * b61 >= 1;
s.t. M2: b1 * b12 + b2 * b22 + b3 * b32 + b4 * b42 + b5 * b52 + b6 * b62 >= 1;
s.t. M3: b1 * b13 + b2 * b23 + b3 * b33 + b4 * b43 + b5 * b53 + b6 * b63 >= 1;
s.t. M4: b1 * b14 + b2 * b24 + b3 * b34 + b4 * b44 + b5 * b54 + b6 * b64 >= 1;
s.t. M5: b1 * b15 + b2 * b25 + b3 * b35 + b4 * b45 + b5 * b55 + b6 * b65 >= 1;
s.t. M6: b1 * b16 + b2 * b26 + b3 * b36 + b4 * b46 + b5 * b56 + b6 * b66 >= 1;
s.t. M7: b1 * b17 + b2 * b27 + b3 * b37 + b4 * b47 + b5 * b57 + b6 * b67 >= 1;
s.t. M8: b1 * b18 + b2 * b28 + b3 * b38 + b4 * b48 + b5 * b58 + b6 * b68 >= 1;
s.t. M9: b1 * b19 + b2 * b29 + b3 * b39 + b4 * b49 + b5 * b59 + b6 * b69 >= 1;
s.t. M10: b1 * b110 + b2 * b210 + b3 * b310 + b4 * b410 + b5 * b510 + b6 * b610 >= 1;


s.t. M11: b1 * b11 + b2 * b21 + b3 * b31 + b4 * b41 + b5 * b51 + b6 * b61 <= 1;
s.t. M12: b1 * b12 + b2 * b22 + b3 * b32 + b4 * b42 + b5 * b52 + b6 * b62 <= 1;
s.t. M13: b1 * b13 + b2 * b23 + b3 * b33 + b4 * b43 + b5 * b53 + b6 * b63 <= 1;
s.t. M14: b1 * b14 + b2 * b24 + b3 * b34 + b4 * b44 + b5 * b54 + b6 * b64 <= 1;
s.t. M15: b1 * b15 + b2 * b25 + b3 * b35 + b4 * b45 + b5 * b55 + b6 * b65 <= 1;
s.t. M16: b1 * b16 + b2 * b26 + b3 * b36 + b4 * b46 + b5 * b56 + b6 * b66 <= 1;
s.t. M17: b1 * b17 + b2 * b27 + b3 * b37 + b4 * b47 + b5 * b57 + b6 * b67 <= 1;
s.t. M18: b1 * b18 + b2 * b28 + b3 * b38 + b4 * b48 + b5 * b58 + b6 * b68 <= 1;
s.t. M19: b1 * b19 + b2 * b29 + b3 * b39 + b4 * b49 + b5 * b59 + b6 * b69 <= 1;
s.t. M20: b1 * b110 + b2 * b210 + b3 * b310 + b4 * b410 + b5 * b510 + b6 * b610 <= 1;