class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "2.3.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.3.0/trustpin-cli-macos-x64"
      sha256 "71c27ca817edff5a5826892bd34e509932d99e317a9ebe21ecb0b225a74095ff"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.3.0/trustpin-cli-macos-arm64"
      sha256 "d9b95a25ddabfd12d9f4c717843630527ece79f0f575a5f42ab0df92f81b9c31"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.3.0/trustpin-cli-linux-x64"
      sha256 "a65e562e9d798fee49a3ece6a1c58abbe752333526b183205066b5a1ae4aa1ae"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v2.3.0/trustpin-cli-linux-arm64"
      sha256 "6495d2b64e6eba03cc6b4f4fadc4a2a9460b0bb114ddae90c8d4bb02862c8381"
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
