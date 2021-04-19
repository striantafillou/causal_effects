INTRODUCTION
Causal effects includes some basic functions for estimating causal effects in causal graphical models (DAGs/SMCMs)
The package was created in MATLAB R2019a.

CONTENTS
This software provides exact and approximate estimators for pre- and post- intervention conditional probability distributions, using causal graphical models. Causal graphical models are defined in package 
https://github.com/striantafillou/causal_graphs, this package required for using causal_effects. Some of teh code is slightly modified from the BNT and BDAGL packages.

The package includes the following repos:
/estimator: Estimators for P(Y|X, Z) and P(Y|do(X), Z), when a probabilistic graphical model is known. There are two types of estimators: Exhaustive or using Junction Tree (suffix JT), implemented in TETRAD (https://www.ccd.pitt.edu/tools/)
/graph: Functions that check graphical properties related to estimation of causal effects (e.g., adjustment sets). Also calls some algorithms from the causaleffect package in R.
/data: Estimating conditional independencies/ posteriors for the BN from data.
/util: Misc functions  

LICENSE 
This software is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This software is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%