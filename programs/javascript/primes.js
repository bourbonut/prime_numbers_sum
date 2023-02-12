const {performance} = require("perf_hooks");

function P10(n){
    var r = Math.floor(n ** 0.5);
    console.assert(r * r <= n && Math.pow(r + 1, 2) > n);
    var V = [];
    for (let i = 1; i < r + 1; i++){
        V.push(Math.floor(n / i));
    }
    for (let i = V[V.length - 1] - 1; i > 0; i--){
        V.push(i);
    }
    var S = V.reduce((S, i) => {
        S[i] = Math.floor(i * (i + 1) / 2) - 1
        return S;
    }, {});
    var length = V.length;
    for (let p = 2; p < r + 1; p++){
        if (S[p] > S[p - 1]) {
            var sp = S[p - 1];
            var p2 = p * p;
            for (let index = 0; index < length; index++){
                let v = V[index];
                if (v < p2){
                    break;
                }
                S[v] -= p * (S[Math.floor(v / p)] - sp);
            }
        }
    }
    return S[n];
}

function format(dist, value){
    return value + " ".repeat(dist - value.length)
}

console.log("Power | Time (µs) | Resultat")
console.log("========================================")
for (let i=1; i<9; i++){
    var start = performance.now();
    var result = P10(Math.floor(Math.pow(10, i)));
    var duration = Math.floor((performance.now() - start) * 1_000);
    console.log(format(5, String(i)) + " | " + format(9, String(duration)) + " | " + String(result));
}
