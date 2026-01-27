class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "2.2.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.2.0/trustpin-cli-macos-x64"
      sha256 "f8b0dd026442816621e87f31c4400d8f44224e7fd258372e85d1e58fe4ddec46"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.2.0/trustpin-cli-macos-arm64"
      sha256 "632db73f422617da9e204e3dfad76097ca3c372df95b402837a38fb9d3adcf83"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.2.0/trustpin-cli-linux-x64"
      sha256 "27df88a89776bf2cb49058ab7485df0b55be951a3a213e61d3e18a700ad1d2d7"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.2.0/trustpin-cli-linux-arm64"
      sha256 "a7829ed18c88291e4eb50b773435ea4c9ff7352766c94078d7727cf176d40956"
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
