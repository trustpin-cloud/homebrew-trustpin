class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "2.4.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.4.0/trustpin-cli-macos-x64"
      sha256 "c2ba12cc29d0269a2b49b48e00d107799d2fc0dca00a2d29e4af284bf099e5ce"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.4.0/trustpin-cli-macos-arm64"
      sha256 "c452c37d0db4644a1f2219b1a17c16355a9950711fd4f55f1a533ccd66c98bc0"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.4.0/trustpin-cli-linux-x64"
      sha256 "5ad40dba202e7c26ae0a0b04dbc0cee5174d043eff366bc2f4a6d32a684512b3"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.4.0/trustpin-cli-linux-arm64"
      sha256 "aa69691283dbfc30d34d4b160f9046d268e64225b802bd576586b8f995286ce8"
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
