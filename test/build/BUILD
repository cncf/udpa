load("//bazel:api_build_system.bzl", "udpa_cc_test", "udpa_go_test")

licenses(["notice"])  # Apache 2

udpa_cc_test(
    name = "build_test",
    srcs = ["build_test.cc"],
    proto_deps = [
        "//udpa/service/orca/v1:orca",
    ],
)

udpa_go_test(
    name = "go_build_test",
    srcs = ["go_build_test.go"],
    importpath = "go_build_test",
    proto_deps = [
        "//udpa/data/orca/v1:pkg",
        "//udpa/service/orca/v1:pkg",
        "//udpa/type/v1:pkg",
    ],
)
