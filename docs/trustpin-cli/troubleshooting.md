---
layout: default
title: Troubleshooting
---

# Troubleshooting

[Home](index.md) · [Commands](commands.md) · [Automation & CI/CD](automation.md) · **Troubleshooting**

## Debug flags

Three global flags help diagnose problems, available on every command:

```bash
# Verbose: config file location, API URLs, HTTP status codes
trustpin-cli projects list --verbose

# Debug output
trustpin-cli user info --debug

# Log full HTTP requests and responses
trustpin-cli projects list --log-http
```

Example verbose output:

```text
$ trustpin-cli projects list --verbose
Checking configuration...
Config file: /Users/you/.trustpin/cli/config.properties
Configuration is valid
Using API Base URL: https://api.trustpin.cloud
Making request: GET https://api.trustpin.cloud/projects
HTTP Success: GET https://api.trustpin.cloud/projects (200)
```

## Common issues

### "CLI is not configured"

Run the configure flow, or set the environment variables:

```bash
trustpin-cli configure
# or
export TRUSTPIN_API_TOKEN=tp_your_token_here
```

Use `--verbose` on any command to see which config file the CLI is reading.

### Invalid API token (exit code 3, HTTP 401/403)

Check that your token starts with `tp_` and hasn't been revoked, then reconfigure:

```bash
trustpin-cli configure --api-token tp_your_new_token
```

`trustpin-cli user info` is the quickest way to verify credentials.

### HTTP errors (404, 500, …)

Run the failing command with `--verbose` to see the exact request and status:

```text
$ trustpin-cli projects get <org-id> <project-id> --verbose
❌ HTTP Error: GET https://api.trustpin.cloud/projects/...
   Status: 404 Not Found
```

A 404 on `projects get` usually means the organization ID and project ID are swapped or belong to a different organization. Find the right IDs with `trustpin-cli user info` (organization) and `trustpin-cli projects list` (project).

### Homebrew: "Refusing to load formula … from untrusted tap"

Since Homebrew 6.0, third-party taps need a one-time trust approval:

```bash
brew trust trustpin-cloud/trustpin-cli
```

### Changes not visible in my app

`projects upsert` and `projects cleanup` only stage changes. Check for a version mismatch and publish:

```bash
# Compare stored vs published versions
trustpin-cli projects get $ORG_ID $PROJECT_ID     # warns if unpublished
trustpin-cli projects jws $ORG_ID $PROJECT_ID --decode

# Publish
trustpin-cli projects sign $ORG_ID $PROJECT_ID
```

Apps also cache the configuration — allow for their refresh interval.

### Network connectivity

```bash
curl -H "Authorization: Bearer $TRUSTPIN_API_TOKEN" https://api.trustpin.cloud/users
```

## Still stuck?

- Check [docs.trustpin.cloud](https://docs.trustpin.cloud)
- Email [support@trustpin.cloud](mailto:support@trustpin.cloud)
