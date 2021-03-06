#' Uncomment and run the two line below to resume development of this script
# orderly::orderly_develop_start("check_assess-code")
# setwd("src/check_assess-code")

#' Does the code to assess each of the posterior marginals work as intended?
#' There is also a possibility to switch some of the assessment code to use INLA:: inbuilt functions
#' Presumably this would be more efficient? Perhaps make an issue to look into this
#' Might want to know what proportion of the computation is assessing models (if it's not very much then matters less)

#' Just fit a quick constant model on example data
data <- readRDS("depends/data_iid_grid.rds")
sf <- data[[1]]$sf
fit <- bsae::constant_inla(sf)

#' Make up some values for the truth
rho <- rep(0.14, 28)

marginal <- ith_marginal_rho(fit, 1)
plot(marginal$samples)

#' Draws from the posterior marginal
stopifnot(min(marginal$samples) < marginal$mean)
stopifnot(max(marginal$samples) > marginal$mean)
stopifnot(min(marginal$samples) < marginal$mode)
stopifnot(max(marginal$samples) > marginal$mode)

#' A list of the evaluation metrics
metrics <- assess_ith_marginal_rho(rho, fit, 1)

metric_names <- c(
  "obs", "mean", "mode", "lower", "upper", "mse", "mae", "mse_mean",
  "mae_mean", "mse_mode", "mae_mode", "crps", "lds", "quantile"
)

stopifnot(names(metrics) == metric_names)


#' df with columns giving evaluation metrics with first row as above
#' The model fitted is a constant so the metrics should all be equal
df <- assess_marginals_rho(rho, fit)

plot(df$mse)
plot(df$mae)
plot(df$lds)
plot(df$crps)
plot(df$quantile)

#' Test that assess_replicates works as intended
x <- assess_replicates(list(list(rho = rho)), list(fit))

#' This is for the lengthscale test
fit2 <- bsae::ck_stan(mw)
x2 <- assess_replicates(list(list(rho = rho)), list(fit2))

#' Does inla.posterior.sample match $fitted.values
samples_list <- INLA::inla.posterior.sample(n = 100000, fit, selection = list(Predictor = 1))
eta_samples = sapply(samples_list, function(x) x$latent)
samples <- plogis(eta_samples)
samples_df <- data.frame(x = samples)

pdf("inla-posterior.sample-vs-marginal.pdf", h = 4, w = 6.25)

cbpalette <- c("#56B4E9","#009E73", "#E69F00", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#999999")

ggplot(marginal$df) +
  geom_histogram(data = samples_df, aes(x = x, y = ..density..), bins = 100, alpha = 0.5) +
  geom_line(aes(x = x, y = y), col = cbpalette[1])

dev.off()

f <- approxfun(marginal$df$x, marginal$df$y, yleft = 0, yright = 0)

#' Are samples generated outside the range of f (from $fitted.values)
log(f(max(samples))) #' Not -Inf
log(f(min(samples)))

#' Kernel density approach on samples
kde <- density(samples, bw = 0.1, n = 256, from = 0, to = 1)
df2 <- data.frame(x = kde$x, y = kde$y)
plot(df2$x, df2$y) #' What is going on here?
plot(marginal$df$x, marginal$df$y)
f2 <- approxfun(df2$x, df2$y, yleft = 0, yright = 0)
log(f2(max(samples))) #' Not -Inf
log(f2(min(samples)))

#' inla. function testing

#' Should be approximately the same
INLA::inla.dmarginal(0.14, marginal$df, log = TRUE)
log(f(0.14))

#' inla.qmarginals gives the value corresponding to a quantile q
#' inla.pmarginal gives the cumulative distribution function at p
#' Should be approxiamtely the same
INLA::inla.pmarginal(0.14, marginal$df)
cubature::cubintegrate(f, lower = 0, upper = 0.14, method = "pcubature")$integral

#' Do these functions work for df created outside of INLA (I don't see why not)
#' Yes they do, so is it worth switching to them?
fit_stan <- bsae::constant_stan(sf)
marginal_stan <- ith_marginal_rho(fit_stan, 1)
plot(marginal_stan$df$x, marginal_stan$df$y)
plot(df2$x, df2$y)

#' Looks the same as that based upon inla.posterior.sample
INLA::inla.dmarginal(0.14, marginal_stan$df, log = TRUE)
INLA::inla.dmarginal(0.14, df2, log = TRUE)
INLA::inla.pmarginal(0.14, marginal_stan$df)
INLA::inla.pmarginal(0.14, df2)
