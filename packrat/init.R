#### -- Packrat Autoloader (version 0.9.2) -- ####
local({
  # Ensure packrat library paths are set on startup
  old <- .libPaths()
  lib  <- file.path(getwd(), "packrat", "lib", R.version$platform, getRversion())
  lib.out <- file.path(getwd(), "packrat", "lib-ext")
  lib.R   <- file.path(getwd(), "packrat", "lib-R")
  new <- c(if (file.exists(lib)) lib, if (file.exists(lib.out)) lib.out, if (file.exists(lib.R)) lib.R)
  .libPaths(new)
  on.exit(.libPaths(old), add = TRUE)

  # Bootstrap packrat if available
  pkgDir <- file.path(getwd(), "packrat", "lib", R.version$platform, getRversion(), "packrat")
  if (!file.exists(pkgDir)) {
    message("! packrat library not found; run packrat::restore() to initialize")
    return(invisible())
  }
  library(packrat, lib.loc = dirname(pkgDir), warn.conflicts = FALSE)
  packrat::on()
})
