class Gatewayd < Formula
  version "0.8.11"
  url "https://github.com/gatewayd-io/gatewayd/releases/download/v#{version}/gatewayd-darwin-amd64-v#{version}.tar.gz"
  sha256 "1e1c567045dbaebe2663b8dea038b89e391c321d134989844da8d4ab88819171"
  head "https://github.com/gatewayd-io/gatewayd.git", branch: "main"
  desc "☁️ Cloud-native database gateway and framework for building data-driven applications ✨ Like API gateways, for databases ✨"
  homepage "https://gatewayd.io"
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
