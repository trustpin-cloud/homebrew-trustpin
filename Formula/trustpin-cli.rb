class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://trustpin.cloud"
  version "5.0.3"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.3/trustpin-cli-macos-x64"
      sha256 "0ca9318b285f821d5bf27312529a3441e1adf0d9598a9c792ffe19767e525244"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.3/trustpin-cli-macos-arm64"
      sha256 "3374808935dd4aadb11243d7800ab6cdfd7f9d401345f385fc91a30a11cd71ee"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.3/trustpin-cli-linux-x64"
      sha256 "69c5e8dfdc79eecd8a74ab2d785a200a418b4bfaa9e990f5dc788511cd21bf4f"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.3/trustpin-cli-linux-arm64"
      sha256 "974fe3034e130bce617222f432a61ed6051dba6fb4b8f849d06584c96cc3987f"
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
