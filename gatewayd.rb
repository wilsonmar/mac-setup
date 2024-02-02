# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
class Gatewayd < Formula
  desc "☁️ Cloud-native database gateway and framework for building data-driven applications ✨ Like API gateways, for databases ✨"
  homepage "https://gatewayd.io"
  url "https://github.com/gatewayd-io/gatewayd/releases/download/v0.8.11/gatewayd-darwin-amd64-v0.8.11.tar.gz"
  sha256 "1e1c567045dbaebe2663b8dea038b89e391c321d134989844da8d4ab88819171"
  license "AGPL-3.0"

  depends_on "go" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    `gatewayd "version"`
    system "true"
  end
end
