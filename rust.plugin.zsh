# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name: rust
# @brief: Set environment variables for the Rust programming language.
# @repository: https://github.com/johnstonskj/zsh-rust-plugin
# @version: 0.1.1
# @license: MIT AND Apache-2.0
#
# ### Public variables
#
# * `RUST_SRC_PATH`; path to rust source installed by rustup.
#

############################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
# See https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# See https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
declare -gA RUST
RUST[_PLUGIN_DIR]="${0:h}"
RUST[_FUNCTIONS]=""

# Saving the current state for any modified global environment variables.
RUST[_OLD_RUST_SRC_PATH]="${RUST_SRC_PATH:-}"

############A#######################################################################################
# Internal Support Functions
############A#######################################################################################

############A#######################################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

@zplugins_declare_plugin_dependencies cargo shlog

# #
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
        export RUST_SRC_PATH="${RUST_SRC_PATH:-${src_path}}"
    else
        log_error "zsh-rust: command 'rustc' not found, check for cargo plugin"
    fi
}

#
# @description
#
# Called when the plugin is unloaded to clean up after itself.
#
# @noargs
#
rust_plugin_unload() {
    builtin emulate -L zsh

    # Reset global environment variables.
    @zplugin_envvar_restore rust RUST_SRC_PATH
}
