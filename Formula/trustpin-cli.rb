class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "3.0.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v3.0.0/trustpin-cli-macos-x64"
      sha256 "eafdf29ac7aa97cf6dcbf85c1f0b20440bc0540f14744f655e658a06e2c394b1"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v3.0.0/trustpin-cli-macos-arm64"
      sha256 "23fc7991947e768d2d3b0fa7dd1696c3aaf9d099fe7f62b185f95745f8c39859"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v3.0.0/trustpin-cli-linux-x64"
      sha256 "ef1404ad768c6847ae36b96a6490acd12e88ae2f0048a5b6de66be745eed58c0"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v3.0.0/trustpin-cli-linux-arm64"
      sha256 "e271b3ce0759fca9470b9cfc52285306dc3a9bbb430eb0cb5741fbb5f66f49bd"
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
