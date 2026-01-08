class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "2.1.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.1.0/trustpin-cli-macos-x64"
      sha256 "1a99285823d4eeadcebb0b53eccd722d742ebc4f5c872a1e41c06e9023df71c8"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.1.0/trustpin-cli-macos-arm64"
      sha256 "964461067e5624ed91835dfb3020afa802043256e048c9ecc8f93b4cb830f3d4"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.1.0/trustpin-cli-linux-x64"
      sha256 "40ba6a80d5cb75913287f83cc481cf056272b7b3b7c04e0d61b857418cf05cd7"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.1.0/trustpin-cli-linux-arm64"
      sha256 "772a8ae09f7d6b0520600e0f77eb4d10e3d4fd237c332936a2aba532e5fa7ce9"
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
