# AGENT BRIEFING

## Repository Snapshot
- Dotfiles repo for macOS/Linux driven by Dotbot (`install`, `.install.conf.yaml`) with submodules for zsh themes/plugins and solarized dircolors.
- Top-level configs: `bash/`, `zsh/`, `vim/`, `tmux.conf`, `gitconfig`, plus reusable workspace assets under `Workspace/`.
- `install` bootstraps Dotbot then attempts to switch the login shell to zsh when available, while `.install.conf.yaml` symlinks all config files into `$HOME` and cleans vendor/plugin directories before syncing submodules.

## Shell Stack (`shell/`)
### Loader & Conventions
- `load_all.sh` is the entrypoint sourced from `.bashrc`/`.zshrc`. It enforces a load order (core → navigation → tmux → projects → cloud → utilities → dev → web → git → courses → `local.sh`) so later modules can rely on earlier helpers like `_tmux_switch`.
- `bootstrap.sh` prepends `$HOME/.local/bin` and `$HOME/.dotfiles/bin`. `functions.sh` provides low-level helpers for editing `$PATH`, compiling/running C++/Java snippets, unpacking archives, and bookmarking directories via `here`/`there`.
- Many commands assume the curated directory layout (`~/Work`, `~/University`, `~/Config`, etc.) and tmux availability.

### Core Modules
- `core.sh`: switches the shell to vi mode and modern CLI defaults (eza for ls, colorized grep, human-readable `du/df`, guarded `rm/cp/mv`, quick `sysinfo`).
- `navigation.sh`: opinionated `cd` aliases for Work/University/Personal trees plus helpers like `leetcode` (opens leetweb + cd) and multi-level `..` aliases.
- `tmux.sh`: `_tmux_switch` spins up standardized sessions (`code`, `test`, `exec`, `git`, `ai`), seeds commands (`vi .`, `opencode`), and exposes `tp`, `tnew`, `tkill`, `trename`, and tmux aliases.
- `projects.sh`: language-aware jumpers (`cppProject`, `pproj`), project listing/creation (scaffolds cargo, Python venv, C++ folders), and cleanup of build artifacts; relies heavily on `_tmux_switch` so tmux is always prepped.
- `cloud.sh`: opinionated rclone workflows—mount/umount Google Drive, mirror to/from OneDrive, selective project sync (`pullproj`/`bproj` for cloud copies), dedupe, diagnostics, and a detailed `cloud-help` reference. Make sure `rclone` and remotes (`gdrive`, `onedrive`) are configured.
- `utilities.sh`: general helpers (`up`, `mcd`, `jump`, `findfile`, `extract`), clipboard abstraction per OS, productivity commands (`top10`, `note`, `weather`), networking (`ssh_info`, `ports`, `serve`), file hygiene (`bak`, `stats`), and the `codelog` bulk exporter built on `ag` for dumping source trees into a readable log.
- `dev.sh`: quick-edit aliases for every shell component (`editCore`, `editProjects`, etc.), dotfile editors (`vimConfig`, `gitConfig`), reload shortcut, plus language tooling aliases (Python, npm, Maven scaffolding via `mvnInit`).
- `git.sh`: higher-level workflows that exceed gitconfig aliasing—vimdiff-based `grd`, WIP commits, merged-branch cleanup, conflict editing helpers, repo bootstrapper (`ginit`), recursive puller (`gpullall`), and convenience commands like `grepo`, `gcap`, `gundo`.
- `web.sh`: browser launchers for learning/docs (Google search, GitHub profile, LeetCode, MDN, cppreference, etc.) and a `mirrorsite` wget preset.
- `courses.sh`: auto-launchers for MIT/Stanford/CMU course material plus project directory jumpers (`pyProject`, `cppProject`). Expect macOS `open` and local repos (`mit-6.034`, `cmu-15.445`, …).
- `plugins/dircolors-solarized`: vendored palette files; `dircolors.256dark` at the root provides the currently selected scheme.

### Notable Behaviors & Gotchas
- Cross-platform helpers are in place for browser launches (`open` falls back to `xdg-open`/`sensible-browser`) and tmux AI pane launches only fire when `opencode` exists.
- Cloud helpers expect `~/Work/Projects/projects` hierarchy and exclude patterns defined in `~/rclone-exclude.txt`.

## How to Use This Stack
1. Run `./install` to link configs and sync submodules. Confirm your login shell switches to zsh (or update manually).
2. Source `shell/load_all.sh` from `.bashrc`/`.zshrc`. Optionally add a host-specific `shell/local.sh` for machine overrides that stay untracked.
3. Start new work via `newproject <name> [lang]`, then `tnew` to drop into a tmux workspace. Use `tp` to fuzzy-jump existing repos.
4. Keep backups flowing with `backup-all`/`cloud-sync`, mirror to Google Drive via `mirror-to-gdrive`, and monitor status with `gstatus`/`cloud-check`.
5. Lean on `dev.sh` aliases to edit configs quickly and `reload` to re-source the environment after changes.

## Additional Notes
- `zsh/` contains theme configs (Powerlevel10k, gitstatus binaries) and plugin sources mirrored as submodules; keep them updated via `git submodule update`.
- `Workspace/` and `Work/` paths referenced throughout are user-specific; adjust navigation aliases if your filesystem layout differs.
- For diagnostics or sharing, `codelog` can capture the textual state of any repo while ignoring common build artifacts, producing a portable `code.log` (one sample already exists at `shell/code.log`).
