class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "5.0.1"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.1/trustpin-cli-macos-x64"
      sha256 "eefa4fa99f83a3793bcc79d675899eb65fbeb582c561e69626b805bdf83cc369"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.1/trustpin-cli-macos-arm64"
      sha256 "c473ecfd4ea4cecdcf21e979390a23b0beded6c6c8918a9a6c99eea14dda9f87"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.1/trustpin-cli-linux-x64"
      sha256 "74a6d761e2ce8387a8b31800d56c50898435c07e30af9f26b6bec656fd3c5792"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.1/trustpin-cli-linux-arm64"
      sha256 "79b9543a0164a7263b983178445d92aff305572211639630ec8c94dafd5be7ac"
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
