# SigPloit in a Box 🐳📡

A minimal, no-fuss Docker build for [SigPloit](https://github.com/SigPloiter/SigPloit) — the SS7 / GTP / Diameter / SIP telecom signaling exploitation framework

> **This repo ships a `Dockerfile`, not the tool.** SigPloit itself is cloned fresh from the upstream repo at build time and is © its original authors under the MIT License. See [Credits](#credits--license) below.

---

## Why this exists

SigPloit is a genuinely useful framework for authorized telecom signaling security testing — but it also predates a lot of modern tooling:

- Hard-pinned to **Python 2.7** (EOL since 2020)
- Needs **SCTP** kernel/userspace support that most laptops don't ship with
- Its `requirements.txt` uses loose `>=` version bounds, which happily resolve to modern, Python-3-only package releases that hard-crash under Python 2

This Dockerfile solves all three so you get a working environment in one `docker build`.

## What's inside

| Layer | Purpose |
|---|---|
| `ubuntu:18.04` | Last Ubuntu LTS with Python 2.7 in the standard repos |
| `python2.7`, `python-pip`, `python-dev` | Runtime + headers to compile C extensions |
| `default-jre-headless` | Satisfies SigPloit's Java 1.7+ requirement |
| `lksctp-tools`, `libsctp-dev` | SCTP runtime libs + headers (needed to build `pysctp`) |
| `build-essential` | Compiler toolchain for native pip packages |
| `pyfiglet==0.7.5` (pinned) | Last release before pyfiglet dropped Python 2 support |

## Quick start

```bash
git clone <this-repo>
cd <this-repo>

docker build -t sigploit .
docker run -it --rm --net=host sigploit
```

### Why `--net=host`?

SCTP (the transport SigPloit uses for SS7/M3UA) doesn't play nicely with Docker's default bridged/NAT'd network. For real interconnect or lab testing, run on the host network stack directly rather than through Docker's bridge.

## Known gotchas

- **`pyfiglet` SyntaxError under Python 2** — already patched here via a `sed` pin to `0.7.5` before install. If you fork this and add new dependencies, watch for the same trap: any loosely-pinned (`>=`) package can silently resolve to a Python-3-only release.
- **Python 2.7 is EOL** — no security patches upstream. This container is meant for isolated lab/testing use, not as a long-lived production service.
- Want a modern Python 3 stack instead? Check out the community fork [`shiky8/SigFramework`](https://github.com/shiky8/SigFramework), which ports SigPloit to Python 3.

## Intended use

This is built for **authorized security testing and research only** — SS7/telecom pentesting in labs you own or have explicit written permission to test. Signaling networks are shared, sensitive infrastructure; unauthorized use against real operator networks is illegal in essentially every jurisdiction.

## Credits & License

- **SigPloit** — created by [Loay Abdelrazek (SigPloiter)](https://github.com/SigPloiter) and contributors, licensed under the [MIT License](https://github.com/SigPloiter/SigPloit/blob/master/LICENSE). Not modified or redistributed here — pulled fresh from upstream at build time.
- **This Dockerfile** — © [your name], licensed under the [MIT License](./LICENSE).
