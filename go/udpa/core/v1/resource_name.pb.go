// Code generated by protoc-gen-go. DO NOT EDIT.
// source: udpa/core/v1/resource_name.proto

package udpa_core_v1

import (
	fmt "fmt"
	_ "github.com/cncf/udpa/go/udpa/annotations"
	_ "github.com/envoyproxy/protoc-gen-validate/validate"
	proto "github.com/golang/protobuf/proto"
	math "math"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.ProtoPackageIsVersion3 // please upgrade the proto package

type ResourceName struct {
	Id                   []string       `protobuf:"bytes,1,rep,name=id,proto3" json:"id,omitempty"`
	Authority            string         `protobuf:"bytes,2,opt,name=authority,proto3" json:"authority,omitempty"`
	QualifiedType        string         `protobuf:"bytes,3,opt,name=qualified_type,json=qualifiedType,proto3" json:"qualified_type,omitempty"`
	Context              *ContextParams `protobuf:"bytes,4,opt,name=context,proto3" json:"context,omitempty"`
	XXX_NoUnkeyedLiteral struct{}       `json:"-"`
	XXX_unrecognized     []byte         `json:"-"`
	XXX_sizecache        int32          `json:"-"`
}

func (m *ResourceName) Reset()         { *m = ResourceName{} }
func (m *ResourceName) String() string { return proto.CompactTextString(m) }
func (*ResourceName) ProtoMessage()    {}
func (*ResourceName) Descriptor() ([]byte, []int) {
	return fileDescriptor_cadec11c867fca74, []int{0}
}

func (m *ResourceName) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_ResourceName.Unmarshal(m, b)
}
func (m *ResourceName) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_ResourceName.Marshal(b, m, deterministic)
}
func (m *ResourceName) XXX_Merge(src proto.Message) {
	xxx_messageInfo_ResourceName.Merge(m, src)
}
func (m *ResourceName) XXX_Size() int {
	return xxx_messageInfo_ResourceName.Size(m)
}
func (m *ResourceName) XXX_DiscardUnknown() {
	xxx_messageInfo_ResourceName.DiscardUnknown(m)
}

var xxx_messageInfo_ResourceName proto.InternalMessageInfo

func (m *ResourceName) GetId() []string {
	if m != nil {
		return m.Id
	}
	return nil
}

func (m *ResourceName) GetAuthority() string {
	if m != nil {
		return m.Authority
	}
	return ""
}

func (m *ResourceName) GetQualifiedType() string {
	if m != nil {
		return m.QualifiedType
	}
	return ""
}

func (m *ResourceName) GetContext() *ContextParams {
	if m != nil {
		return m.Context
	}
	return nil
}

func init() {
	proto.RegisterType((*ResourceName)(nil), "udpa.core.v1.ResourceName")
}

func init() { proto.RegisterFile("udpa/core/v1/resource_name.proto", fileDescriptor_cadec11c867fca74) }

var fileDescriptor_cadec11c867fca74 = []byte{
	// 286 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xff, 0x54, 0x8f, 0xbd, 0x4e, 0xc3, 0x30,
	0x14, 0x85, 0x65, 0xb7, 0xf4, 0xc7, 0x14, 0x04, 0x59, 0x88, 0x4a, 0x91, 0x02, 0x53, 0x27, 0x47,
	0x05, 0x31, 0xb1, 0x99, 0x1d, 0x45, 0x11, 0x7b, 0x74, 0x9b, 0x18, 0x6a, 0xa9, 0x89, 0x83, 0x73,
	0x1d, 0x91, 0x8d, 0x67, 0xe0, 0x3d, 0x78, 0x01, 0x9e, 0x80, 0x95, 0xd7, 0xe9, 0x84, 0x92, 0x34,
	0x10, 0x36, 0xcb, 0xe7, 0x3b, 0x57, 0xe7, 0x63, 0x9e, 0x4d, 0x72, 0xf0, 0x63, 0x6d, 0xa4, 0x5f,
	0xae, 0x7c, 0x23, 0x0b, 0x6d, 0x4d, 0x2c, 0xa3, 0x0c, 0x52, 0xc9, 0x73, 0xa3, 0x51, 0x3b, 0xb3,
	0x9a, 0xe0, 0x35, 0xc1, 0xcb, 0xd5, 0xfc, 0xa2, 0xe1, 0x21, 0xcb, 0x34, 0x02, 0x2a, 0x9d, 0x15,
	0x7e, 0x81, 0x80, 0xb6, 0x68, 0xe1, 0xf9, 0xe5, 0xbf, 0x73, 0xb1, 0xce, 0x50, 0xbe, 0x62, 0x94,
	0x83, 0x81, 0xb4, 0x43, 0xce, 0x4a, 0xd8, 0xaa, 0x04, 0x50, 0xfa, 0xdd, 0xa3, 0x0d, 0xae, 0x3e,
	0x08, 0x9b, 0x85, 0xfb, 0x01, 0x0f, 0x90, 0x4a, 0xc7, 0x65, 0x54, 0x25, 0x2e, 0xf1, 0x06, 0xcb,
	0xa9, 0x98, 0xec, 0xc4, 0xc1, 0x3b, 0xa1, 0x13, 0x12, 0x52, 0x95, 0x38, 0x0b, 0x36, 0x05, 0x8b,
	0x1b, 0x6d, 0x14, 0x56, 0x2e, 0xf5, 0xc8, 0x72, 0x1a, 0xfe, 0x7d, 0x38, 0x9c, 0x1d, 0xbf, 0x58,
	0xd8, 0xaa, 0x27, 0x25, 0x93, 0x08, 0xab, 0x5c, 0xba, 0x83, 0x1a, 0x11, 0xe3, 0x9d, 0x18, 0x1a,
	0x7a, 0x42, 0xc2, 0xa3, 0xdf, 0xf8, 0xb1, 0xca, 0xa5, 0x73, 0xcb, 0xc6, 0xfb, 0xa5, 0xee, 0xd0,
	0x23, 0xcb, 0xc3, 0xeb, 0x73, 0xde, 0x77, 0xe6, 0xf7, 0x6d, 0x18, 0x34, 0x16, 0x61, 0xc7, 0x8a,
	0xbb, 0xcf, 0xb7, 0xaf, 0xef, 0x11, 0x9d, 0x10, 0xb6, 0x88, 0x75, 0xca, 0x9f, 0x15, 0x6e, 0xec,
	0xba, 0x6d, 0xf6, 0xeb, 0xe2, 0xb4, 0x2f, 0x15, 0xd4, 0xaa, 0x01, 0x59, 0x8f, 0x1a, 0xe7, 0x9b,
	0x9f, 0x00, 0x00, 0x00, 0xff, 0xff, 0x4c, 0xe2, 0xb7, 0xd7, 0x80, 0x01, 0x00, 0x00,
}
