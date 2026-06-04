//! Raw bindgen FFI for libmgba — the *only* place raw mGBA names appear.
//! Generated at build time (see build.rs). Everything else in the harness
//! goes through the safe wrapper in `emu`, per the project rule of keeping
//! `unsafe` confined to thin FFI boundaries.

#![allow(non_upper_case_globals, non_camel_case_types, non_snake_case, dead_code)]

include!(concat!(env!("OUT_DIR"), "/mgba_sys.rs"));
