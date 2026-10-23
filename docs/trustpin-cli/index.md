---
layout: default
title: Home
---

# TrustPin CLI

The official command-line interface for [TrustPin](https://trustpin.cloud) certificate pinning management. Manage certificate pinning configurations, discover certificate pins for your domains, and sign and publish configurations that your mobile apps consume — from your terminal or your CI/CD pipeline.

**Documentation**

- [Command Reference](commands.md) — every command, flag, and example
- [Automation & CI/CD](automation.md) — JSON output, exit codes, environment variables, GitHub Actions
- [Troubleshooting](troubleshooting.md) — common issues and debug flags

## Features

- **Secure configuration management** — store API credentials locally, or supply them via environment variables
- **Project management** — list, inspect, and update TrustPin projects
- **Domain certificate lookup** — discover SSL/TLS certificates and pins for any domain, including certificates found in Certificate Transparency logs
- **Pin lifecycle** — add and update pins, and clean up expired ones
- **Signing & publishing** — sign configurations as JWS with cloud-managed keys or your own key (BYOK) and publish them to the TrustPin CDN
- **App attestation** — edit, sign and publish attestation policies, and download the deployment bundle of the self-hosted verifier
- **Machine-readable output** — `--output json` and stable exit codes for automation
- **Cross-platform** — native binaries for macOS and Linux (Intel & ARM)

## Installation

Install via Homebrew (macOS and Linux, Intel & ARM):

```bash
# Add the TrustPin tap
brew tap trustpin-cloud/trustpin-cli

# Trust the tap (required once — Homebrew 6.0+ blocks installs from untrusted third-party taps)
brew trust trustpin-cloud/trustpin-cli

# Install
brew install trustpin-cli
```

> **Why `brew trust`?** Since Homebrew 6.0, installing from a third-party tap requires a
> one-time, per-user trust approval. Without it you'll see
> `Error: Refusing to load formula … from untrusted tap`. Trust is a local decision on
> your machine — there is no way for us to pre-approve the tap on your behalf.

Using a `Brewfile` with `brew bundle`? Record the trust approval inline so installs don't prompt or fail:

```ruby
tap "trustpin-cloud/trustpin-cli"
brew "trustpin-cloud/trustpin-cli/trustpin-cli", trusted: true
```

## Quick start

```bash
# 1. Configure the CLI with your API token (prompts interactively)
trustpin-cli configure

# 2. Verify your credentials and see your organizations
trustpin-cli user info

# 3. List your projects
trustpin-cli projects list

# 4. Discover certificate pins for a domain
trustpin-cli domains certificates api.example.com

# 5. Add a pin to a project
trustpin-cli projects upsert <organization-id> <project-id> \
  --domain api.example.com \
  --pin spki-sha256:oxVSdCLgthL3M5Vnnzepq8WWlkUfRPYkpjLpm+wn+1o= \
  --expires 2026-04-13T08:37:02Z

# 6. Sign and publish the configuration
trustpin-cli projects sign <organization-id> <project-id>
```

Your mobile apps pick up the newly published configuration from the TrustPin CDN on their next refresh.

See the [Command Reference](commands.md) for full details on every command.

## Typical workflow

1. **Discover pins** — `domains certificates` shows the live certificate and any certificates found in Certificate Transparency logs for a domain, with ready-to-use pin values.
2. **Update the project** — `projects upsert` adds or updates a pin for a domain; `projects cleanup` removes pins that have already expired.
3. **Publish** — `projects sign` signs the configuration as a JWS and publishes it to the CDN. Until you sign, changes are staged but not live.
4. **Verify** — `projects jws` fetches the currently published configuration, optionally verifying its signature and decoding its payload.

## Support

- Documentation: [docs.trustpin.cloud](https://docs.trustpin.cloud)
- Email: [support@trustpin.cloud](mailto:support@trustpin.cloud)

## License

Distributed under the TrustPin Binary License Agreement — see the [full license text](LICENSE.txt).
