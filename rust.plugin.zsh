# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# Plugin Name: rust
# Repository: https://github.com/johnstonskj/zsh-rust-plugin
#
# Description:
#
#   Zsh plugin to set additional Rust environment variables.
#
# Public variables:
#
# * `RUST`; plugin-defined global associative array with the following keys:
#   * `_ALIASES`; a list of all aliases defined by the plugin.
#   * `_FUNCTIONS`; a list of all functions defined by the plugin.
#   * `_PLUGIN_DIR`; the directory the plugin is sourced from.
# * `RUST_SRC_PATH`; path to rust source installed by rustup.
#

############################################################################
# Standard Setup Behavior
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# See https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
declare -gA RUST
RUST[_PLUGIN_DIR]="${0:h}"
RUST[_FUNCTIONS]=""

# Saving the current state for any modified global environment variables.
RUST[_OLD_RUST_SRC_PATH]="${RUST_SRC_PATH:-}"

############################################################################
# Internal Support Functions
############################################################################

#
# This function will add to the `RUST[_FUNCTIONS]` list which is
# used at unload time to `unfunction` plugin-defined functions.
#
# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
# See https://wiki.zshell.dev/community/zsh_plugin_standard#the-proposed-function-name-prefixes
#
.rust_remember_fn() {
    builtin emulate -L zsh

    local fn_name="${1}"
    if [[ -z "${RUST[_FUNCTIONS]}" ]]; then
        RUST[_FUNCTIONS]="${fn_name}"
    elif [[ ",${RUST[_FUNCTIONS]}," != *",${fn_name},"* ]]; then
        RUST[_FUNCTIONS]="${RUST[_FUNCTIONS]},${fn_name}"
    fi
}
.rust_remember_fn .rust_remember_fn

#
# This function does the initialization of variables in the global variable
# `RUST`. It also adds to `path` and `fpath` as necessary.
#
rust_plugin_init() {
    builtin emulate -L zsh
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
}
.rust_remember_fn rust_plugin_init

############################################################################
# Plugin Unload Function
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
rust_plugin_unload() {
    builtin emulate -L zsh

    # Remove all remembered functions.
    local plugin_fns
    IFS=',' read -r -A plugin_fns <<< "${RUST[_FUNCTIONS]}"
    local fn
    for fn in ${plugin_fns[@]}; do
        whence -w "${fn}" &> /dev/null && unfunction "${fn}"
    done

    # Reset global environment variables .
    export RUST_SRC_PATH="${RUST[_OLD_RUST_SRC_PATH]}"

    # Remove the global data variable.
    unset RUST

    # Remove this function.
    unfunction rust_plugin_unload
}

############################################################################
# Public Functions
############################################################################

rust_example() {
    builtin emulate -L zsh

    printf "An example function in rust, var: ${RUST_EXAMPLE}"
}
.rust_remember_fn rust_example



############################################################################
# Initialize Plugin
############################################################################

rust_plugin_init

true
