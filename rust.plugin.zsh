# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name: rust
# @brief: Set environment variables for the Rust programming language.
# @repository: https://github.com/johnstonskj/zsh-rust-plugin
# @version: 0.1.1
# @license: MIT AND Apache-2.0
#
# @description
#
# At this point the plugin _only_ manages the `RUST_SRC_PATH` environment variable.
#
# ### Public variables
#
# * `RUST_SRC_PATH`; path to rust source installed by rustup.
#

############A#######################################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

@zplugins_declare_plugin_dependencies rust cargo shlog

#
# @description
#
# This function initializes the `RUST_SRC_PATH` variable.
#
# @noargs
#
rust_plugin_init() {
    builtin emulate -L zsh

    if command -v rustc >/dev/null 2>&1; then
        # Save current state of `RUST_SRC_PATH` and initialize if not set.
        local src_path="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
        @zplugins_envvar_save rust RUST_SRC_PATH
        typeset -g RUST_SRC_PATH="${RUST_SRC_PATH:-${src_path}}"
    else
        log_error "zsh-rust: command 'rustc' not found, check for cargo plugin"
    fi
}

#
# @description
#
# Called when the plugin is unloaded to restore RUST_SRC_PATH`.
#
# @noargs
#
rust_plugin_unload() {
    builtin emulate -L zsh

    # Reset global environment variables.
    @zplugin_envvar_restore rust RUST_SRC_PATH
}
