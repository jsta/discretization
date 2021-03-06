#' Exploring coverage of multi-model-averaged confidence intervals
#' 

#+ knitr_setup
library(knitr)
opts_chunk$set(echo=FALSE)

#+ pkgs
library(MASS)
library(plyr)
library(reshape2)
library(ggplot2); theme_set(theme_bw())
source("R/mmasim_funs.R")

#+ setup
resfn <- c("c_arr","f_arr","f20_arr","fzc_arr")
resnames <- c("mma","full10","full20","full10_zerocor")
results <- setNames(lapply(sprintf("simdata/%s.rds",resfn),readRDS),
                    resfn)

##' residuals
dd_res <- Map(res_est,results,resnames)
dd_res <- do.call(rbind,dd_res)
ggplot(dd_res,aes(x=param,y=value,colour=method))+
              stat_summary(fun.data=mean_cl_normal)+
    coord_flip()
##' why is the last (smallest true value) variable less biased?

##' rmse
dd_rmse <- Map(rmse_est,results,resnames)
dd_rmse <- do.call(rbind,dd_rmse)
ggplot(dd_rmse,aes(x=param,y=rmse,colour=method))+
    geom_point()+
    coord_flip()
##' why is RMSE highest for mma? is this a correlated-effect problem??
##' or a bug?

##' coverage
dd <- Map(cov_est,results,resnames)
dd <- do.call(rbind,dd)
ggplot(dd,aes(par,cover,ymin=cover-2*se,ymax=cover+2*se,col=method))+
    geom_pointrange(position=position_dodge(width=0.5))+
    geom_hline(yintercept=0.95,lty=2)+
    scale_colour_brewer(palette="Set1")

##' confidence interval widths
dd_CI <- Map(CI_est,results,resnames)
dd_CI <- do.call(rbind,dd_CI)
ggplot(dd_CI,aes(x=true_CIw,colour=method))+
    geom_pointrange(aes(y=avg_CIw,ymin=avg_CIw-1.96*se_CIw,
                        ymax=avg_CIw+1.96*se_CIw))+
    geom_abline(slope=1,intercept=0,lty=2)+
    scale_colour_brewer(palette="Set1")


