load("//bazel:api_build_system.bzl", "udpa_cc_test")

licenses(["notice"])  # Apache 2

udpa_cc_test(
    name = "build_test",
    srcs = ["build_test.cc"],
    proto_deps = [
        "//udpa/service/orca/v1:orca",
    ],
)
