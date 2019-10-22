library("dplyr")
library(glpkAPI)

rm(list=ls())

solveMIP = function(mat, rlower, rupper, clower, cupper, obj, types, fname1, fname2)
{
  nrows = dim(mat)[1]
  ncols = dim(mat)[2]
  
  ## initialize model
  lp = initProbGLPK()
  
  # maximize objective GLP_Max (minimize with GLP_MIN)
  setObjDirGLPK(lp,GLP_MIN)
  
  # tell model how many rows and columns
  addRowsGLPK(lp, nrows)
  addColsGLPK(lp, ncols)
  
  # add bounds
  setColsBndsGLPK(lp, c(1:ncols), clower, cupper)
  setRowsBndsGLPK(lp, c(1:nrows), rlower, rupper)
  
  setObjCoefsGLPK(lp, c(1:ncols), obj)
  
  setColsKindGLPK(lp, 1:ncols, types)
  
  ## use sparse format for model data
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
  getObjValGLPK(lp)
  
  # # value of variables in optimal solution
  # getColsPrimGLPK(lp)
  # # status of each variable in optimal solution 1 = basic variable
  # getColsStatGLPK(lp)
  
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
  writeMIPGLPK(lp, fname2)
  
  # This is supposed to get all at once
  # getRowsDualGLPK(lp)
}

prepMIP = function(mat, pChar1Target, pChar3Target, sCharTarget, target, countTarget, fname1, fnam2)
{
  nrows = 44
  ncols = 70
  
  ## row upper and lower bounds
  rlower = c(1, pChar1Target, pChar3Target, sCharTarget, target, rep(-Inf, 15), -Inf, rep(1, 5))
  rupper = c(1, pChar1Target, pChar3Target, sCharTarget, target, rep(0, 15), count, rep(1, 5))
  
  ## column upper and lower bounds
  clower = rep(0, ncols)
  cupper = rep(1, ncols)
  
  # set the objective
  obj = c(rep(0, 15), rep(3, 10), rep(2, 30), rep(0, 15))
  
  # set the type of variables
  types = c(rep(GLP_CV, 55), rep(GLP_BV, 15));
  solveMIP(mat, rlower, rupper, clower, cupper, obj, types, fname1, fname2)
}

eye5 = diag(1, 5)
eye15 = diag(1, 15)

# Zach:
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
pChars = cbind(rbind(e, pChar1, pChar3), , diag(0, 3, 55))
sChars = cbind(rbind(sChar1, sChar2, sChar3, sChar4, sChar5), eye5, -eye5, diag(0, 5, 15), diag(0, 5, 30))
equalities = cbind(eye15, diag(0, 15, 10), eye15, -eye15, diag(0, 15, 15))
binaries = cbind(eye15, diag(0, 15, 40), -eye15)
count = c(rep(0, 55), rep(1, 15))
already_invested = rbind(c(rep(0, 1, 55), 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                         c(rep(0, 1, 55), 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                         c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0),
                         c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
                         c(rep(0, 1, 55), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1))
mat = rbind(pChars, sChars, equalities, binaries, count, already_invested) # 3 + 5 + 15  + 15 + 1 + 5

# Model 1:
target = c(0.3, 0.09, 0.07, 0.2, 0.08, 0.06, 0.03, 0.03, 0.02, 0.02, 0.01, 0.02, 0.07, 0.0, 0.0)
pChar1Target = 0.93
pChar3Target = 0.07
sCharTarget = c(0.511, 0.106, 0.07, 0.03, 0.00)
countTarget = 6
fname1 = "solution-1-M1-Zach.txt"
fname2 = "solution-2-M1-Zach.txt"
prepMIP(mat, pChar1Target, pChar3Target, sCharTarget, target, countTarget, fname1, fnam2)