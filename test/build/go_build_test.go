package go_build_test

import (
	"testing"

	_ "github.com/envoyproxy/go-control-plane/udpa/data/orca/v1"
	_ "github.com/envoyproxy/go-control-plane/udpa/service/orca/v1"
	_ "github.com/envoyproxy/go-control-plane/udpa/type/v1"
)

func TestNoop(t *testing.T) {
	// Noop test that verifies the successful importation of UDPA protos
}
