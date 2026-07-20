---
layout: default
title: Command Reference
---

# Command Reference

[Home](index.md) · **Commands** · [Automation & CI/CD](automation.md) · [Troubleshooting](troubleshooting.md)

```
trustpin-cli
├── configure                  Configure API credentials
├── user
│   └── info                   Show current user and organizations
├── projects
│   ├── list                   List projects
│   ├── get                    Show project details
│   ├── config                 Get configuration as JWS payload (JSON)
│   ├── upsert                 Add or update a certificate pin
│   ├── cleanup                Remove expired certificate pins
│   ├── sign                   Sign and publish configuration as JWS
│   └── jws                    Fetch the published JWS from the CDN
└── domains
    └── certificates           Look up certificates and pins for a domain
```

### Global flags

Available on every command:

| Flag | Description |
|---|---|
| `--verbose` | Verbose output: config file location, API URLs, HTTP status codes |
| `--debug` | Debug output |
| `--log-http` | Log HTTP requests and responses |
| `--version` | Print the CLI version |

Most commands also accept `--output json` for machine-readable output (see [Automation & CI/CD](automation.md)).

---

## configure

Configure the CLI with your TrustPin API credentials. Runs interactively when flags are omitted.

```bash
trustpin-cli configure [--api-base-url <url>] [--api-token <token>]
```

```text
$ trustpin-cli configure
API Base URL (https://api.trustpin.cloud): https://api.trustpin.cloud
API Token: tp_your_token_here
Configuration saved successfully!
```

Credentials are stored in `~/.trustpin/cli/config.properties`. You can also configure the CLI entirely through environment variables — see [Automation & CI/CD](automation.md#environment-variables).

---

## user info

Show the authenticated user and their organizations. Useful as a quick credentials check, and for finding your organization ID.

```bash
trustpin-cli user info [--output json]
```

```text
$ trustpin-cli user info
═══ User Information ═══
ID: 6f0c1a2b-3d4e-5f60-7182-93a4b5c6d7e8
Name: Jane Developer
Email: jane@example.com

── Organizations ──
• Example Org (0a1b2c3d-4e5f-6071-8293-a4b5c6d7e8f9)
```

---

## projects list

List all projects you have access to, with their IDs, type, domain count, and publish status.

```bash
trustpin-cli projects list [--output json]
```

```bash
# Extract project names for scripting
trustpin-cli projects list --output json | jq -r '.data.projects[].name'
```

---

## projects get

Show detailed information about one project: configuration and published versions, public key, and per-domain pin counts. Warns when the latest configuration version has not been published yet.

```bash
trustpin-cli projects get <organization-id> <project-id> [--output json]
```

```text
$ trustpin-cli projects get 0a1b2c3d-4e5f-6071-8293-a4b5c6d7e8f9 9f8e7d6c-5b4a-3928-1706-f5e4d3c2b1a0
═══ Project Details ═══
Name: Example Mobile App
Type: Managed CDN with Cloud Keys
Configuration Version: 3
Published Version: 2
⚠️  Warning: Latest configuration (v3) is not yet published (v2)
Domains: 2
    • Domain: example.com        (1 pin)
    • Domain: api.example.com    (1 pin)
```

---

## projects config

Print the project's current (stored, not necessarily published) configuration in JWS payload format. Output is always JSON.

```bash
trustpin-cli projects config <organization-id> <project-id>
```

---

## projects upsert

Add a certificate pin to a domain in a project, or update an existing pin's expiration. If the domain does not exist in the project yet, it is added.

```bash
trustpin-cli projects upsert <organization-id> <project-id> \
  --domain <fqdn> \
  --pin <type>:<value> \
  [--expires <ISO8601-datetime>] \
  [--dry-run] \
  [--output json]
```

| Flag | Description |
|---|---|
| `--domain` | Domain name (FQDN) — required |
| `--pin` | Pin as `<type>:<value>` — required |
| `--expires` | Pin expiration (ISO 8601, e.g. `2026-04-13T08:37:02Z`) |
| `--dry-run` | Show the request that would be sent without submitting it |

**Pin types**

| Type | Meaning |
|---|---|
| `spki-sha256` | SPKI SHA-256 fingerprint (recommended) |
| `spki-sha512` | SPKI SHA-512 fingerprint |
| `sha256` | Certificate SHA-256 fingerprint |
| `sha512` | Certificate SHA-512 fingerprint |

SPKI pins are recommended because they pin the public key rather than a specific certificate, so they survive certificate renewals that reuse the same key pair.

```bash
$ trustpin-cli projects upsert $ORG_ID $PROJECT_ID \
    --domain api.example.com \
    --pin spki-sha256:oxVSdCLgthL3M5Vnnzepq8WWlkUfRPYkpjLpm+wn+1o= \
    --expires 2026-04-13T08:37:02Z
✓ Domain: api.example.com
  • Added pin: spki-sha256:oxVSdCLgth... (expires 2026-04-13T08:37:02Z)

✓ Project updated successfully
  Configuration version: 5 → 6
  ⚠️  Remember to sign and publish: trustpin-cli projects sign ...
```

> **Note:** `upsert` updates the stored configuration only. Changes are not live until you run [`projects sign`](#projects-sign).

Combine with `domains certificates` to pin a discovered certificate in one step:

```bash
SPKI=$(trustpin-cli domains certificates api.example.com --output json | \
  jq -r '.data.certificates[0].spkiSha256')

trustpin-cli projects upsert $ORG_ID $PROJECT_ID \
  --domain api.example.com \
  --pin spki-sha256:$SPKI \
  --expires 2026-04-13T08:37:02Z
```

---

## projects cleanup

Remove already-expired certificate pins from every domain in a project.

```bash
trustpin-cli projects cleanup <organization-id> <project-id> [--dry-run] [--output json]
```

- Only pins whose expiration is set **and in the past** are removed; pins without an expiry are kept.
- Domains are never removed — a domain left with zero pins remains in the project.
- The configuration version is incremented only when at least one pin is removed, and the operation is idempotent.
- Use `--dry-run` to see how many pins would be removed without changing anything, and add `--verbose` for a per-domain breakdown.

```text
$ trustpin-cli projects cleanup $ORG_ID $PROJECT_ID --dry-run
Dry run: 2 expired pin(s) would be removed (no changes made)

  Run without --dry-run to remove them: trustpin-cli projects cleanup ...

$ trustpin-cli projects cleanup $ORG_ID $PROJECT_ID
Removed 2 expired pin(s)

  ⚠️  Remember to sign and publish: trustpin-cli projects sign ...
```

> **Note:** like `upsert`, `cleanup` updates the stored configuration only — run [`projects sign`](#projects-sign) afterwards to publish.

---

## projects sign

Sign the project's current configuration as a JWS and publish it to the TrustPin CDN. This is what makes staged changes live for your apps.

```bash
trustpin-cli projects sign <organization-id> <project-id> \
  [--private-key <path>] [--password <password>] [--output json]
```

| Flag | Description |
|---|---|
| `-k, --private-key` | Path to a PEM private key file — required for BYOK projects |
| `-p, --password` | Master password for private key decryption (prompted interactively if omitted) |

**Cloud-managed keys** — for projects of type *Managed CDN with Cloud Keys*, no key file is needed; you'll be prompted for your master password:

```text
$ trustpin-cli projects sign $ORG_ID $PROJECT_ID
Master password: ****
[1/5] Getting project information
[2/5] Loading project configuration
[3/5] Preparing private key
[4/5] Creating and signing JWT
[5/5] Uploading signed configuration
Configuration published successfully!
```

**Bring Your Own Key (BYOK)** — for BYOK projects, supply your private key:

```bash
trustpin-cli projects sign $ORG_ID $PROJECT_ID --private-key ./my-private-key.pem
```

---

## projects jws

Fetch the currently **published** JWS configuration from the CDN — the exact payload your mobile apps are fetching.

```bash
trustpin-cli projects jws <organization-id> <project-id> \
  [--verify] [--decode] [--output-file <path>]
```

| Flag | Description |
|---|---|
| `--verify` | Verify the JWS signature using the public key from the CDN |
| `--decode` | Decode and display the JWS header and payload |
| `--output-file` | Save the raw JWS to a file |

```text
$ trustpin-cli projects jws $ORG_ID $PROJECT_ID --decode
JWS Header:
  Algorithm: ES256
  Type: JWT

Payload:
  Spec: v1.0.0
  Version: 3
  Issued At: 2026-06-11T13:24:44Z
  Domains: 1
    - api.example.com (2 pins)

Current DB Version: 3
Published Version: 3

Published version is up to date
```

Use cases:

- **Verify what's live** — check the configuration currently served to production apps
- **Validate signing** — confirm that `projects sign` actually published
- **Debug pinning issues** — compare what the app fetches with what you expect
- **Testing & auditing** — save the JWS for local testing (`--output-file`) or compliance archives

---

## domains certificates

Look up all known SSL/TLS certificates for a domain: the live certificate plus any discovered via Certificate Transparency logs. Every certificate is reported with all four pin formats, its expiration, CAA issuer, and CT log information — ready to use with `projects upsert`.

```bash
trustpin-cli domains certificates <domain-name> [--output json]
```

```text
$ trustpin-cli domains certificates api.example.com

═══ Certificates for api.example.com ═══
  Total certificates: 2

── Certificate 1 ──
  Common Name: api.example.com
  Issuer: Let's Encrypt Authority X3
  SHA-256: heXXXV6YUWtMPE/dUyZ6ESBpkOibPSeHseRAnp4dQJg=
  SPKI SHA-256: oxVSdCLgthL3M5Vnnzepq8WWlkUfRPYkpjLpm+wn+1o=
  Expires At: 2026-04-13T08:37:02Z
  CAA Issuer: letsencrypt.org
  CT SCT Logs: 2
```
