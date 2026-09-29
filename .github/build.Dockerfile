# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM tonistiigi/xx:latest@sha256:c64defb9ed5a91eacb37f96ccc3d4cd72521c4bd18d5442905b95e2226b0e707 AS xx

# Run the compilers on the builder's CPU, including when targeting ARM64.
FROM --platform=$BUILDPLATFORM golang:1.27.1-alpine AS build
COPY --from=xx / /
RUN apk add --no-cache clang lld musl-dev linux-headers build-base file

ARG TARGETARCH
# Install target headers and libraries into the cross-compiler's sysroot.
RUN xx-apk add --no-cache musl-dev linux-headers gcc g++
ENV CGO_ENABLED=1 \
    CC=xx-clang \
    CXX=xx-clang++ \
    CGO_LDFLAGS="-fuse-ld=lld"

ARG UPSTREAM_TAG
RUN test -n "$UPSTREAM_TAG" && \
    xx-go install \
      -trimpath \
      -buildvcs=false \
      -ldflags "-X 'github.com/sagernet/sing-box/constant.Version=${UPSTREAM_TAG}' -linkmode external -checklinkname=0 -extldflags=-static -s -compressdwarf=true -w -buildid=''" \
      -tags 'with_quic with_grpc with_dhcp with_wireguard with_utls with_acme with_clash_api with_v2ray_api with_gvisor with_embedded_tor with_lwip staticOpenssl staticZlib staticLibevent' \
      "github.com/sagernet/sing-box/cmd/sing-box@${UPSTREAM_TAG}" && \
    bin_dir="$(go env GOPATH)/bin" && \
    if xx-info is-cross; then bin_dir="${bin_dir}/$(xx-go env GOOS)_$(xx-go env GOARCH)"; fi && \
    mkdir /out && \
    cp "${bin_dir}/sing-box" "/out/sing-box-${TARGETARCH}" && \
    xx-verify --static "/out/sing-box-${TARGETARCH}"

FROM scratch AS binaries
COPY --from=build /out/ /
