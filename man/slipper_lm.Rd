% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/slipper_lm.R
\name{slipper_lm}
\alias{slipper_lm}
\title{Bootstrap a linear regression model}
\usage{
slipper_lm(df, formula, null_formula = NULL, B = 100, boot_resid = FALSE)
}
\arguments{
\item{df}{A data frame}

\item{formula}{A bare formula to pass to the lm command}

\item{null_formula}{(optional) If NULL, standard bootstrapping is performed. If a bare nested null formula is passed the bootstrapped statistics come from the null.}

\item{B}{the number of bootstrap samples to draw}

\item{boot_resid}{If TRUE then bootstrapping residuals is performed.}
}
\value{
out A data frame with the values, whether they come from the observed data or the bootstrapped data, and the coefficient name.
}
\description{
Takes a data frame, and a model to fit to the data
and each bootstrap replicate. Bootstrapping is by
default resampling cases, but if you set boot_resid=TRUE
then resampling residuals will be performed. If you
pass a null model formula that includes a subset
of the variables in the full model (i.e. it is a 
nested model) then the bootstrap statistics will
come from the bootstrapped null data and can be
used for a hypothesis test.
}
\examples{

# Bootstrap a regression model 
slipper_lm(mtcars,mpg ~ cyl,B=100)

# Bootstrap a regression model with piping
mtcars \%>\% slipper_lm(mpg ~ cyl,B=100)

# Bootstrap residuals for a regression model
mtcars \%>\% slipper_lm(mpg ~ cyl,B=100,boot_resid=TRUE)

# Bootsrap confidence intervals
mtcars \%>\% slipper_lm(mpg ~ cyl,B=100) \%>\% 
filter(type=="bootstrap",term=="cyl") \%>\%
 summarize(ci_low = quantile(value,0.025),
           ci_high = quantile(value,0.975))
           
# Bootstrap hypothesis test - here I've added one to the numerator
# and denominator because bootstrap p-values should never be zero.

boot = mtcars \%>\% slipper_lm(mpg ~ cyl, null_formula = mpg ~ 1,B=1000) \%>\%
                     filter(term=="cyl") \%>\%
                     summarize(num = sum(abs(value) >= abs(value[1])),
                               den = n(),
                               pval = num/den)
}

