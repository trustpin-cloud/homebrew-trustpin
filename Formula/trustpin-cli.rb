class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "2.0.7"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.0.7/trustpin-cli-macos-x64"
      sha256 "82d7dc68d2cb3dc4bf8615dca7bca9cb04dc50be15e4570ff218d03422fa9778"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.0.7/trustpin-cli-macos-arm64"
      sha256 "ccae364b904e4f3d503743f2a88f0e590b62f4149da824d014bea0dda0f442eb"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.0.7/trustpin-cli-linux-x64"
      sha256 "e1d8f10ccb704bc8f428686c2b44aec81de955bea18ef283a74c7b5d50097e14"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.0.7/trustpin-cli-linux-arm64"
      sha256 "b61195eaa137f5c0f0bb7790edd486c22360b45ecb162daa84fe3852495f8839"
    end
  end

  def install
    os = OS.mac? ? "macos" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    binary_name = "trustpin-cli-#{os}-#{arch}"

    # Ensure the binary has execute permissions
    chmod 0755, binary_name

    bin.install binary_name => "trustpin-cli"
  end

  test do
    system "#{bin}/trustpin-cli", "--version"
  end
end
