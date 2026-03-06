# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @rust rust
# @brief Zsh plugin to set additional Rust environment variables.
# @repository https://github.com/johnstonskj/zsh-rust-plugin
#
# ### Public Variables
#
# * `RUST_SRC_PATH`; path to rust source installed by rustup.
#

############################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

rust_plugin_init() {
    builtin emulate -L zsh

    @zplugins_envvar_save rust RUST_SRC_PATH
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
}

# @internal
rust_plugin_unload() {
    builtin emulate -L zsh

    @zplugins_envvar_restore rust RUST_SRC_PATH
}
