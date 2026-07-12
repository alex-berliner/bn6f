// Generate Rust FFI for the vendored libmgba under ../libmgba/
// (i.e. tools/libmgba/). Override with MGBA_PREFIX=/usr for a system install.
//
// This is plumbing carried over from the old bn6f-validate crate — re-deriving
// the libmgba binding from scratch would be pure waste. The *harness logic*
// (src/) is what we're rebuilding from first principles.

use std::env;
use std::path::PathBuf;

fn main() {
    let prefix = env::var("MGBA_PREFIX").unwrap_or_else(|_| {
        let manifest = env::var("CARGO_MANIFEST_DIR").unwrap();
        PathBuf::from(&manifest)
            .parent()
            .unwrap()
            .join("libmgba")
            .to_string_lossy()
            .into_owned()
    });
    let mgba_include = format!("{prefix}/include");
    let mgba_lib = format!("{prefix}/lib");

    println!("cargo:rustc-link-search=native={mgba_lib}");
    println!("cargo:rustc-link-lib=dylib=mgba");
    println!("cargo:rustc-link-arg=-Wl,-rpath,{mgba_lib}");
    println!("cargo:rerun-if-changed=wrapper.h");
    println!("cargo:rerun-if-env-changed=MGBA_PREFIX");

    let bindings = bindgen::Builder::default()
        .header("wrapper.h")
        .clang_arg(format!("-I{}", mgba_include))
        .clang_arg("-DENABLE_VFS=1")
        .clang_arg("-DENABLE_DIRECTORIES=1")
        // Narrow the surface to what we actually call.
        .allowlist_function("mCore.*")
        .allowlist_function("VFile.*")
        .allowlist_function("VFileFromMemory")
        .allowlist_function("VFileOpen")
        .allowlist_function("mLog.*")
        .allowlist_function("ARMSetExecCounts")
        .allowlist_type("mCore")
        .allowlist_type("VFile")
        .allowlist_type("mCoreConfig")
        .allowlist_type("mPlatform")
        .allowlist_type("ARMCore")
        .allowlist_var("mLOG_.*")
        .derive_default(true)
        .layout_tests(false)
        .generate()
        .expect("bindgen failed");

    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("mgba_sys.rs"))
        .expect("bindings write");
}
