---
layout: default
title: Automation & CI/CD
---

# Automation & CI/CD

[Home](index.md) · [Commands](commands.md) · **Automation & CI/CD** · [Troubleshooting](troubleshooting.md)

The CLI is designed for unattended use: every command supports JSON output, credentials can come from environment variables, and exit codes are stable and documented.

## Environment variables

Skip `trustpin-cli configure` entirely by exporting credentials — ideal for CI runners and containers. Set variables take precedence over the configuration file; an empty one counts as unset:

```bash
export TRUSTPIN_API_BASE_URL=https://api.trustpin.cloud
export TRUSTPIN_API_TOKEN=tp_your_token_here
```

Alternatively, the CLI reads `~/.trustpin/cli/config.properties`:

```properties
TRUSTPIN_API_BASE_URL=https://api.trustpin.cloud
TRUSTPIN_API_TOKEN=tp_your_token_here
```

## JSON output

Pass `--output json` to any command for machine-readable output. Every response has the same envelope:

```json
{
  "status": "success",
  "operation": "projects-list",
  "data": { }
}
```

```bash
# Parse with jq
trustpin-cli projects list --output json | jq -r '.data.projects[].name'

# Assert success in scripts
if trustpin-cli user info --output json | jq -e '.status == "success"' > /dev/null; then
  echo "Credentials are valid"
fi
```

## Exit codes

| Code | Meaning |
|---|---|
| `0` | Success |
| `1` | Configuration error (CLI not configured) |
| `2` | API error |
| `3` | Authentication error |
| `4` | Validation error (bad arguments or input) |
| `5` | Resource not found |
| `6` | Key error |
| `7` | File error |
| `8` | Cryptography error |
| `9` | Cancelled by user |
| `10` | Permission error |
| `99` | Unexpected error |

## Batch operations

```bash
# Get details for every project
PROJECT_IDS=$(trustpin-cli projects list --output json | jq -r '.data.projects[].id')

for id in $PROJECT_IDS; do
  trustpin-cli projects get "$ORG_ID" "$id" --output json | jq -r '.data.project.name'
done
```

## GitHub Actions example

A workflow that extracts a pin from a certificate, upserts it into a project, and signs and publishes the configuration:

```yaml
name: Deploy Certificate Pinning
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install TrustPin CLI
        run: |
          eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
          brew tap trustpin-cloud/trustpin-cli
          brew trust trustpin-cloud/trustpin-cli
          brew install trustpin-cli

      - name: Extract certificate pin
        id: pins
        run: |
          SPKI_PIN=$(openssl x509 -in cert.pem -pubkey -noout | \
            openssl pkey -pubin -outform der | \
            openssl dgst -sha256 -binary | \
            base64)
          EXPIRES=$(openssl x509 -in cert.pem -noout -enddate | \
            cut -d= -f2 | \
            xargs -I{} date -d "{}" -u +%Y-%m-%dT%H:%M:%SZ)
          echo "spki_pin=$SPKI_PIN" >> $GITHUB_OUTPUT
          echo "expires=$EXPIRES" >> $GITHUB_OUTPUT

      - name: Update certificate pin
        env:
          TRUSTPIN_API_TOKEN: ${{ secrets.TRUSTPIN_API_TOKEN }}
        run: |
          trustpin-cli projects upsert \
            ${{ vars.ORG_ID }} ${{ vars.PROJECT_ID }} \
            --domain api.example.com \
            --pin spki-sha256:${{ steps.pins.outputs.spki_pin }} \
            --expires ${{ steps.pins.outputs.expires }} \
            --output json

      - name: Sign and publish configuration
        env:
          TRUSTPIN_API_TOKEN: ${{ secrets.TRUSTPIN_API_TOKEN }}
        run: |
          trustpin-cli projects sign \
            ${{ vars.ORG_ID }} ${{ vars.PROJECT_ID }} \
            --password ${{ secrets.MASTER_PASSWORD }}
```

## Scheduled maintenance: pruning expired pins

Expired pins accumulate as certificates rotate. A scheduled job can prune them safely — `cleanup` is idempotent and never removes domains:

```yaml
name: Prune expired pins
on:
  schedule:
    - cron: "0 6 * * 1"   # Mondays 06:00 UTC

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - name: Install TrustPin CLI
        run: |
          eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
          brew tap trustpin-cloud/trustpin-cli
          brew trust trustpin-cloud/trustpin-cli
          brew install trustpin-cli

      - name: Remove expired pins
        env:
          TRUSTPIN_API_TOKEN: ${{ secrets.TRUSTPIN_API_TOKEN }}
        run: |
          REMOVED=$(trustpin-cli projects cleanup \
            ${{ vars.ORG_ID }} ${{ vars.PROJECT_ID }} \
            --output json | jq '.data.removed_pins')

          if [ "$REMOVED" -gt 0 ]; then
            trustpin-cli projects sign \
              ${{ vars.ORG_ID }} ${{ vars.PROJECT_ID }} \
              --password ${{ secrets.MASTER_PASSWORD }}
          fi
```

## Tips for automated signing

- For **cloud-key** projects, pass the master password with `--password` (from a secret store) to avoid the interactive prompt.
- For **BYOK** projects, write the PEM key from your secret store to a temporary file, pass it with `--private-key`, and delete it afterwards.
- `projects upsert` and `projects cleanup` only stage changes — a pipeline is not done until `projects sign` succeeds.
- Use `projects jws --verify` as a post-deploy check that the published configuration is live and correctly signed.

## Publishing attestation policies

`projects attestation update` stores a policy kept in your repository, and `projects attestation sign` publishes it. `sign` succeeds without signing when the current version is already published, so the pair is safe to run on every merge:

```bash
trustpin-cli projects attestation update "$ORG_ID" "$PROJECT_ID" --file attestation.json
trustpin-cli projects attestation sign "$ORG_ID" "$PROJECT_ID" --private-key "$KEY_FILE" --output json
```

A full GitHub Actions workflow, signing in one job and publishing from another, and the error codes are in the [attestation DevOps guide](https://github.com/trustpin-cloud/cloud-console-cli/blob/main/DEVOPS_ATTESTATION.md).

> **Note on certificate renewals:** if your certificate authority generates a new key pair on renewal (AWS ACM does, for example), SPKI pins change with every renewal. Automate the upsert-and-sign flow around your renewal events, and consider keeping both the old and new pins active during rollover so apps have time to fetch the updated configuration.
