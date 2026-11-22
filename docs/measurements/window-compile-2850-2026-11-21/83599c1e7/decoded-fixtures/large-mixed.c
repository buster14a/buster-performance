int host;struct Row { int *at; char blob[4200]; };struct Row a[2]={{&host,"a"},{&host,"b"}}; int f(void){return a[1].blob[0];}
