class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "0.2.0"
  
  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin/releases/download/v0.2.0/trustpin-cli-macos-x64"
      sha256 ""
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin/releases/download/v0.2.0/trustpin-cli-macos-arm64"
      sha256 ""
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin/releases/download/v0.2.0/trustpin-cli-linux-x64"
      sha256 ""
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin/releases/download/v0.2.0/trustpin-cli-linux-arm64"
      sha256 ""
    end
  end

  def install
    bin.install "trustpin-cli-#{OS.mac? ? "macos" : "linux"}-#{Hardware::CPU.arch}" => "trustpin-cli"
  end

  test do
    system "#{bin}/trustpin-cli", "--version"
  end
end
