class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "2.0.6"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.0.6/trustpin-cli-macos-x64"
      sha256 "65a53cd9a5a7b4e7dc2abf9e67d941a90c0b39322016789c4124d2c6146efef9"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.0.6/trustpin-cli-macos-arm64"
      sha256 "df67c0813295ca86e30fa9d71632abcfb764b4892aa66e88351647e75260606a"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.0.6/trustpin-cli-linux-x64"
      sha256 "b20e7733279a71f84cf7aab229de78305235ce9e385626aa22df9c67aa4fad09"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.0.6/trustpin-cli-linux-arm64"
      sha256 "512c44f04e6e3a8c9cf926970d0cbced527bb2e55c0af098d189b1e377787fd8"
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
