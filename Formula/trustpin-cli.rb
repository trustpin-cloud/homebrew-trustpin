class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "4.0.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v4.0.0/trustpin-cli-macos-x64"
      sha256 "7bb463fda9f53a647cf23018b93c6d6dda1c225a7dc03cb42e57262bdc185342"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v4.0.0/trustpin-cli-macos-arm64"
      sha256 "7b08625937a504343adeee7682d410202a71aa215f1aafcb841f0d2c3478303f"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v4.0.0/trustpin-cli-linux-x64"
      sha256 "22b0a74551837b58b8c05ec994217562fd4a4914ee07a66a1ccf084c7a903d06"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v4.0.0/trustpin-cli-linux-arm64"
      sha256 "9bc4aa16e1d32574718d7171c214df57eaa7d95046db81206c585f8560a67405"
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
