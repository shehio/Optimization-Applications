set cols;
set rows;

var y{p in cols} >= 0;
var value;
param payoff{r in rows, p in cols};
minimize objective: value;
subject to rowlimit{r in rows}: value - sum{p in cols} payoff[r,p] * y[p] >= 0;
subject to mix: sum{p in cols} y[p] = 1;