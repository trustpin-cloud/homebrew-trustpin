class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "5.0.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.0/trustpin-cli-macos-x64"
      sha256 "d345cdb25d9f85eaa547320decd5b16d303122c5bec392c883196d5bec7a703c"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.0/trustpin-cli-macos-arm64"
      sha256 "ef76387fea40f21f9c19790750eeee013e542976269b5441fda78674604d3ead"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.0/trustpin-cli-linux-x64"
      sha256 "07437e714aaa66e07880835635a59eb116bd3e71669319ecf81f698c619e62a8"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.0/trustpin-cli-linux-arm64"
      sha256 "2fa72bde5f5092985d4b6123e850c0f190d63447e7390013bc94a1ef06cf1e86"
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
