class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://trustpin.cloud"
  version "6.0.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v6.0.0/trustpin-cli-macos-x64"
      sha256 "40389c349a9903a516f18790755ecaae55e7ddc2984b25e7f56b8367fbc7b893"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v6.0.0/trustpin-cli-macos-arm64"
      sha256 "b37ed6c7cabb7be80f11620cc095abc7628012ad8c7f93863bd183937566ce90"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v6.0.0/trustpin-cli-linux-x64"
      sha256 "5bb889bc6ae131d2caef0fb6ec59f97aab95a5f400bc7ecb902494f522afce83"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v6.0.0/trustpin-cli-linux-arm64"
      sha256 "6b683fbcdde46c0a430364645f1e063149ce6a1f5a1fd696aa4a6303c7cbc091"
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
