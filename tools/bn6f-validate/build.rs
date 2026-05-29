// Generate Rust FFI for vendored libmgba 0.11 under ../libmgba/.
// Override path with MGBA_PREFIX=/usr to fall back to system install.

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
        // Narrow the surface — only the symbols we actually use.
        .allowlist_function("mCore.*")
        .allowlist_function("FFmpegEncoder.*")
        .allowlist_function("VFile.*")
        .allowlist_function("VFileFromMemory")
        .allowlist_function("VFileOpen")
        .allowlist_function("mLog.*")
        .allowlist_type("mCore")
        .allowlist_type("FFmpegEncoder")
        .allowlist_type("VFile")
        .allowlist_type("mPlatform")
        .allowlist_var("mLOG_.*")
        .allowlist_var("O_.*")
        .derive_default(true)
        .layout_tests(false)
        .generate()
        .expect("bindgen failed");

    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("mgba_sys.rs"))
        .expect("bindings write");
}
