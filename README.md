# TrustPin

## TrustPin CLI

A powerful command-line interface for TrustPin certificate pinning management. Manage your certificate pinning configurations, sign JWS payloads, and deploy secure mobile applications with confidence.

## Features

- 🔐 **Secure Configuration Management**: Store API credentials securely
- 👤 **User Management**: Get user information and organization details
- 📁 **Project Management**: List, view, and manage TrustPin projects
- 🔑 **Certificate Signing**: Sign and publish certificate pinning configurations
- 📊 **Machine-Readable Output**: JSON output for CI/CD integration
- 🔧 **Cross-Platform**: Native binaries for macOS and Linux (Intel & ARM)
- 🚀 **AWS CLI-style**: Familiar command structure and error handling
- ☁️ **Automation-friendly**: JSON output and stable exit codes for CI/CD ([see the automation guide](docs/trustpin-cli/automation.md))

### Installation

```sh
# Add TrustPin tap
brew tap trustpin-cloud/trustpin-cli

# Trust the tap (required once on Homebrew 6.0+)
brew trust trustpin-cloud/trustpin-cli

# Install TrustPin CLI
brew install trustpin-cli
```

### Update

```sh
brew update
brew upgrade trustpin-cli
```

### Documentation

Full documentation for the TrustPin CLI lives in [docs/](docs/index.md):

- [Getting started](docs/trustpin-cli/index.md)
- [Command Reference](docs/trustpin-cli/commands.md)
- [Automation & CI/CD](docs/trustpin-cli/automation.md)
- [Troubleshooting](docs/trustpin-cli/troubleshooting.md)

### License

Distributed under the TrustPin Binary License Agreement — see [LICENSE](LICENSE).
