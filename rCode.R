library("causaleffect")
library("igraph")
fig1 <- graph.formula(X1-+X2,X3-+X1,X4-+X2,X1-+X3,X4-+X3,X2-+X4,X3-+X4,simplify =TRUE)
fig1 <- set.edge.attribute(graph = fig1, name = "description", index = 2:7, value = "U")
ce1 <- causal.effect(y = "X2", x = "X1", z = "X4", G = fig1, expr = TRUE, simp=TRUE)
ce1
