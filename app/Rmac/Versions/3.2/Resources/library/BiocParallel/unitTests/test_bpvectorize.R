library(doParallel)

test_bpvectorize_Params <- function()
{
    registerDoParallel(2)
    params <- list(serial=SerialParam(),
                   snow=SnowParam(2),
                   batchjobs=BatchJobsParam(workers=2),
                   dopar=DoparParam())
    if (.Platform$OS.type != "windows")
        params$mc <- MulticoreParam(2)

    x <- 1:10
    expected <- sqrt(x)
    for (param in names(params)) {
        psqrt <- bpvectorize(sqrt, BPPARAM=params[[param]])
        checkIdentical(expected, psqrt(x))
    }

    ## clean up
    env <- foreach:::.foreachGlobals
    rm(list=ls(name=env), pos=env)
    closeAllConnections()
    TRUE
}
