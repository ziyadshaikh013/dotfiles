-- Use the fvm-pinned Flutter SDK (<project>/.fvm/flutter_sdk) instead of a
-- global Flutter install. Requires `fvm install` to have run in the project.
return {
  "nvim-flutter/flutter-tools.nvim",
  opts = {
    fvm = true,
  },
}
