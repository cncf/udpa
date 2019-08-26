load("@com_google_protobuf//:protobuf.bzl", _py_proto_library = "py_proto_library")
load("@com_envoyproxy_protoc_gen_validate//bazel:pgv_proto_library.bzl", "pgv_cc_proto_library")
load("@io_bazel_rules_go//proto:def.bzl", "go_grpc_library", "go_proto_library")
load("@io_bazel_rules_go//go:def.bzl", "go_test")

_PY_SUFFIX = "_py"
_CC_SUFFIX = "_cc"
_GO_SUFFIX = "_go"
_GO_IMPORTPATH_PREFIX = "github.com/cncf/udpa/"

_COMMON_PROTO_DEPS = [
    "@com_google_protobuf//:any_proto",
    "@com_google_protobuf//:descriptor_proto",
    "@com_google_protobuf//:duration_proto",
    "@com_google_protobuf//:empty_proto",
    "@com_google_protobuf//:struct_proto",
    "@com_google_protobuf//:timestamp_proto",
    "@com_google_protobuf//:wrappers_proto",
    "@com_google_googleapis//google/api:http_proto",
    "@com_google_googleapis//google/api:annotations_proto",
    "@com_google_googleapis//google/rpc:status_proto",
    "@com_envoyproxy_protoc_gen_validate//validate:validate_proto",
]

def _Suffix(d, suffix):
    return d + suffix

def _LibrarySuffix(library_name, suffix):
    # Transform //a/b/c to //a/b/c:c in preparation for suffix operation below.
    if library_name.startswith("//") and ":" not in library_name:
        library_name += ":" + Label(library_name).name
    return _Suffix(library_name, suffix)

# TODO(htuch): has_services is currently ignored but will in future support
# gRPC stub generation.
# TODO(htuch): Add support for Go based on envoy_api as needed.
def udpa_proto_library(
        name,
        visibility = ["//visibility:private"],
        srcs = [],
        deps = [],
        has_services = None):
    native.proto_library(
        name = name,
        srcs = srcs,
        deps = deps + _COMMON_PROTO_DEPS,
        visibility = visibility,
    )
    pgv_cc_proto_library(
        name = _Suffix(name, _CC_SUFFIX),
        cc_deps = [_LibrarySuffix(d, _CC_SUFFIX) for d in deps] + [
            "@com_google_googleapis//google/api:http_cc_proto",
            "@com_google_googleapis//google/api:annotations_cc_proto",
            "@com_google_googleapis//google/rpc:status_cc_proto",
        ],
        deps = [":" + name],
        visibility = visibility,
    )
    py_export_suffixes = []
    _py_proto_library(
        name = _Suffix(name, _PY_SUFFIX),
        srcs = srcs,
        default_runtime = "@com_google_protobuf//:protobuf_python",
        protoc = "@com_google_protobuf//:protoc",
        deps = [_LibrarySuffix(d, _PY_SUFFIX) for d in deps] + [
            "@com_envoyproxy_protoc_gen_validate//validate:validate_py",
            "@com_google_googleapis//google/rpc:status_py_proto",
            "@com_google_googleapis//google/api:annotations_py_proto",
            "@com_google_googleapis//google/api:http_py_proto",
            "@com_google_googleapis//google/api:httpbody_py_proto",
        ],
        visibility = visibility,
    )
    py_export_suffixes = ["_py", "_py_genproto"]

    # Allow unlimited visibility for consumers
    export_suffixes = ["", "_cc", "_cc_validate"] + py_export_suffixes
    for s in export_suffixes:
        native.alias(
            name = name + "_export" + s,
            actual = name + s,
            visibility = ["//visibility:public"],
        )

def udpa_cc_test(name, srcs, proto_deps):
    native.cc_test(
        name = name,
        srcs = srcs,
        deps = [_LibrarySuffix(d + "_export", _CC_SUFFIX) for d in proto_deps],
    )

# This defines googleapis py_proto_library. The repository does not provide its definition and requires
# overriding it in the consuming project (see https://github.com/grpc/grpc/issues/19255 for more details).
def py_proto_library(name, deps = []):
    srcs = [dep[:-6] + ".proto" if dep.endswith("_proto") else dep for dep in deps]
    proto_deps = []

    # py_proto_library in googleapis specifies *_proto rules in dependencies.
    # By rewriting *_proto to *.proto above, the dependencies in *_proto rules are not preserved.
    # As a workaround, manually specify the proto dependencies for the imported python rules.
    if name == "annotations_py_proto":
        proto_deps = proto_deps + [":http_py_proto"]
    _py_proto_library(
        name = name,
        srcs = srcs,
        default_runtime = "@com_google_protobuf//:protobuf_python",
        protoc = "@com_google_protobuf//:protoc",
        deps = proto_deps + ["@com_google_protobuf//:protobuf_python"],
        visibility = ["//visibility:public"],
    )

def udpa_proto_package(name = "pkg", srcs = [], deps = [], has_services = False, visibility = ["//visibility:public"]):
    """
    Generate a single go_proto for all protos in the package.

    Some packages may have multiple proto files, and therefore multiple blaze proto targets.
    For golang, this is not ideal. Non-bazel users will have to manually generate the protos in a different structure.
    Instead of generating a go_proto target per proto, this rule generates a single go_proto target
    for the entire package. This better adheres to golang's import structure in the OSS world.

    More information: https://github.com/envoyproxy/envoy/pull/8003
    """
    if srcs == []:
        srcs = native.glob(["*.proto"])

    native.proto_library(
        name = name,
        srcs = srcs,
        deps = deps + _COMMON_PROTO_DEPS,
        visibility = visibility,
    )

    compilers = ["@io_bazel_rules_go//proto:go_proto", "//bazel:pgv_plugin_go"]
    if has_services:
        compilers = ["@io_bazel_rules_go//proto:go_grpc", "//bazel:pgv_plugin_go"]

    go_proto_library(
        name = _Suffix(name, _GO_SUFFIX),
        compilers = compilers,
        importpath = _Suffix(_GO_IMPORTPATH_PREFIX, native.package_name()),
        proto = name,
        visibility = ["//visibility:public"],
        deps = [_LibrarySuffix(d, _GO_SUFFIX) for d in deps] + [
            "@com_github_golang_protobuf//ptypes:go_default_library",
            "@com_github_golang_protobuf//ptypes/any:go_default_library",
            "@com_github_golang_protobuf//ptypes/duration:go_default_library",
            "@com_github_golang_protobuf//ptypes/struct:go_default_library",
            "@com_github_golang_protobuf//ptypes/timestamp:go_default_library",
            "@com_github_golang_protobuf//ptypes/wrappers:go_default_library",
            "@com_envoyproxy_protoc_gen_validate//validate:go_default_library",
            "@com_google_googleapis//google/api:annotations_go_proto",
            "@com_google_googleapis//google/rpc:status_go_proto",
        ],
    )

def udpa_go_test(name, srcs, importpath, proto_deps):
    go_test(
        name = name,
        srcs = srcs,
        importpath = _GO_IMPORTPATH_PREFIX + importpath,
        deps = [_LibrarySuffix(d, _GO_SUFFIX) for d in proto_deps],
    )
