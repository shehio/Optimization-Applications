rm(list=ls())

library("dplyr")
library(glpkAPI)

solveMIP = function(mat, rlower, rupper, clower, cupper, obj, types, fname1, fname2, onlySimplex = FALSE)
{
  nrows = dim(mat)[1]
  ncols = dim(mat)[2]
  
  lp = initProbGLPK()
  setObjDirGLPK(lp, GLP_MIN)
  addRowsGLPK(lp, nrows)
  addColsGLPK(lp, ncols)
  
  # add bounds, objective, and kinds
  setColsBndsGLPK(lp, c(1:ncols), clower, cupper)
  setRowsBndsGLPK(lp, c(1:nrows), rlower, rupper)
  setObjCoefsGLPK(lp, c(1:ncols), obj)
  setColsKindGLPK(lp, 1:ncols, types)
  
  # use sparse format for model data
  rownames(mat) = c(1:dim(mat)[1])
  colnames(mat) = c(1:dim(mat)[2])
  sparseMatrix = as.data.frame(as.table(mat))
  colnames(sparseMatrix) = c("row","col","value")
  sparseMatrix = sparseMatrix %>% filter(value != 0)
  
  nonzero = dim(sparseMatrix)[1]
  
  # load constraint matrix coefficients
  loadMatrixGLPK(lp, nonzero, sparseMatrix$row, sparseMatrix$col, sparseMatrix$value)
  
  # solve LP problem using Simplex Method for relaxation
  solveSimplexGLPK(lp)
  print(getObjValGLPK(lp))
  
    if (onlySimplex)
    {
      printRangesGLPK(lp, fname = fname2)
      
      print("Rows Dual: ================")
      print(getRowsDualGLPK(lp))
      
      print("Cols Dual: ================")
      print(getColsDualGLPK(lp))
      return()
    }
  
  # solve it again as a mixed integer program
  solveMIPGLPK(lp)
  
  # get results of solution, if solve status 5 = optimal solution found
  getSolStatGLPK(lp)
  status_codeGLPK(getSolStatGLPK(lp))
  
  # objective function value
  print(mipObjValGLPK(lp))
  print(mipColsValGLPK(lp))
  
  # print the solution
  printSolGLPK(lp, fname1)
}

prepMIP = function(mat, pChar1Target, pChar3Target, sCharTarget, target, countTarget, fname1, fname2, isZach, onlySimplex = FALSE)
{
  nrows = dim(mat)[1]
  ncols = dim(mat)[2]
  
  if (isZach)
  {
    allocations = 5
  }
  else
  {
    allocations = 7
  }
  
  if (onlySimplex)
  {
    allocations = allocations + 1
  }
  
  ## row upper and lower bounds
  rlower = c(1, pChar1Target, pChar3Target, sCharTarget, target, rep(-Inf, 15), -Inf, rep(1, allocations))
  rupper = c(1, pChar1Target, pChar3Target, sCharTarget, target, rep(0, 15), countTarget, rep(1, allocations))
  
  ## column upper and lower bounds
  clower = rep(0, ncols)
  cupper = rep(1, ncols)
  
  # set the objective
  obj = c(rep(0, 15), rep(3, 10), rep(2, 30), rep(0, 15))
  
  # set the type of variables
  if (onlySimplex)
  {
    types = c(rep(GLP_CV, 70))
  }
  else
  {
    types = c(rep(GLP_CV, 55), rep(GLP_BV, 15))
  }

  solveMIP(mat, rlower, rupper, clower, cupper, obj, types, fname1, fname2, onlySimplex)
}

eye5 = diag(1, 5)
eye15 = diag(1, 15)

# Zach and Yolanda:
# primary constraints
e = rep(1, 15)
pChar1 = c(rep(1, 12), rep(0, 3))
pChar3 = c(rep(0, 7), rep(1, 3), rep(0, 4), 1.0)

# secondary constraints
sChar1 = c(rep(1, 3), 0, 0, 0.55, 0.6, rep(0, 8))
sChar2 = c(0, 0, 1, 0, 0, 0.1, 1, rep(0, 8))
sChar3 = c(rep(0, 7), rep(1, 3), rep(0, 5))
sChar4 = c(rep(0, 10), rep(1, 2), rep(0, 3))
sChar5 = c(rep(0, 13), 1, 0)

## Add ds and deltas to the model
pChars = cbind(rbind(e, pChar1, pChar3), diag(0, 3, 55))
sChars = cbind(rbind(sChar1, sChar2, sChar3, sChar4, sChar5), eye5, -eye5, diag(0, 5, 15), diag(0, 5, 30))
equalities = cbind(eye15, diag(0, 15, 10), eye15, -eye15, diag(0, 15, 15))
binaries = cbind(eye15, diag(0, 15, 40), -eye15)
count = c(rep(0, 55), rep(1, 15))
already_invested_zach = rbind(c(rep(0, 1, 55), 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                         c(rep(0, 1, 55), 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                         c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0),
                         c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
                         c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1))
already_invested_yolanda = rbind(c(rep(0, 1, 55), 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                              c(rep(0, 1, 55), 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                              c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0),
                              c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0),
                              c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0),
                              c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0),
                              c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0))
mat_zach = rbind(pChars, sChars, equalities, binaries, count, already_invested_zach) # 3 + 5 + 15  + 15 + 1 + 5
mat_yolanda = rbind(pChars, sChars, equalities, binaries, count, already_invested_yolanda) # 3 + 5 + 15  + 15 + 1 + 5

## Model 1:
target = c(0.3, 0.09, 0.07, 0.2, 0.08, 0.06, 0.03, 0.03, 0.02, 0.02, 0.01, 0.02, 0.07, 0.0, 0.0)
pChar1Target = 0.93
pChar3Target = 0.07
sCharTarget = c(0.511, 0.106, 0.07, 0.03, 0.00)

countTarget = 6
fname1 = "solution-1-M1-Zach.txt"
fname2 = "Sensitivity-Analysis-Zach.txt"
prepMIP(mat_zach, pChar1Target, pChar3Target, sCharTarget, target, countTarget, fname1, fname2, isZach = TRUE)

countTarget = 8
fname1 = "solution-1-M1-Yolanda.txt"
fname2 = "Sensitivity-Analysis-Yolanada.txt"
prepMIP(mat_yolanda, pChar1Target, pChar3Target, sCharTarget, target, countTarget, fname1, fname2, isZach = FALSE)

## Model 2:
target = c(0.24, 0.09, 0.06, 0.11, 0.05, 0.05, 0.03, 0.03, 0.01, 0.01, 0.01, 0.03, 0.26, 0.0, 0.02)
pChar1Target = 0.72
pChar3Target = 0.07
sCharTarget = c(0.4355, 0.095, 0.05, 0.04, 0.26)

countTarget = 6
fname1 = "solution-1-M2-Zach.txt"
fname2 = "Sensitivity-Analysis-Zach.txt"
prepMIP(mat_zach, pChar1Target, pChar3Target, sCharTarget, target, countTarget, fname1, fname2, isZach = TRUE)

countTarget = 8
fname1 = "solution-1-M2-Yolanda.txt"
fname2 = "Sensitivity-Analysis-Yolanada.txt"
prepMIP(mat_yolanda, pChar1Target, pChar3Target, sCharTarget, target, countTarget, fname1, fname2, isZach = FALSE)

## Model 3: Minimizes the penalty for Zach and yolanda.
target = c(0.16, 0.06, 0.04, 0.08, 0.04, 0.03, 0.02, 0.02, 0.01, 0.01, 0.02, 0.04, 0.35, 0.04, 0.08)
pChar1Target = 0.53
pChar3Target = 0.12
sCharTarget = c(0.2885, 0.063, 0.04, 0.06, 0.04)

countTarget = 6
fname1 = "solution-1-M3-Zach.txt"
fname2 = "Sensitivity-Analysis-Zach.txt"
prepMIP(mat_zach, pChar1Target, pChar3Target, sCharTarget, target, countTarget, fname1, fname2, isZach = TRUE)

# Add the binary constraint
already_invested_zach = rbind(already_invested_zach, c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0))
mat_zach = rbind(pChars, sChars, equalities, binaries, count, already_invested_zach)
prepMIP(mat_zach, pChar1Target, pChar3Target, sCharTarget, target, countTarget, fname1, fname2, isZach = TRUE, onlySimplex = TRUE)

countTarget = 8
fname1 = "solution-1-M3-Yolanda.txt"
fname2 = "Sensitivity-Analysis-Yolanada.txt"
prepMIP(mat_yolanda, pChar1Target, pChar3Target, sCharTarget, target, countTarget, fname1, fname2, isZach = FALSE)

# Add the binary constraint
already_invested_yolanda = rbind(already_invested_yolanda, c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0))
mat_yolanda = rbind(pChars, sChars, equalities, binaries, count, already_invested_yolanda)
prepMIP(mat_yolanda, pChar1Target, pChar3Target, sCharTarget, target, countTarget, fname1, fname2, isZach = FALSE, onlySimplex = TRUE)
