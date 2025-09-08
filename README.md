# 🛠️ Khang Huynh Ba’s Dotfiles

A curated collection of configuration files to set up a consistent and efficient development environment across Unix-like systems.-

---

## 📦 Requirements
- Git
- Python 3.7+

---

## 📁 Contents

This repository includes configurations for:

- **Shell**: Custom `.bashrc`, `.bash_profile`, `.inputrc`, and `.editrc` for an enhanced shell experience.
- **Vim**: Tailored `.vimrc` for improved editing capabilities.
- **tmux**: Optimized `.tmux.conf` for terminal multiplexing.
- **Git**: Global `.gitignore` settings via `.gitignore_global`.
- **Installation**: Automated setup using [Dotbot](https://github.com/anishathalye/dotbot) with `.install.conf.yaml` and an `install` script.

---

## 🚀 Installation

To set up these dotfiles on your system:

```bash
git clone https://github.com/kanghuynhba/dotfiles.git
cd dotfiles
chmod +x install
./install
```

This process will symlink the configuration files to your home directory, ensuring a seamless setup.

---

## ⚙️ Customization

Feel free to modify any of the configuration files to suit your preferences. For instance:

- Adjust `.vimrc` to include your favorite plugins or settings.
- Update `.bashrc` with aliases or functions you frequently use.
- Modify `.tmux.conf` to change keybindings or appearance.

---

## 📄 License

This project is licensed under the [Apache-2.0 License](LICENSE).

---

## 🙌 Acknowledgments

Inspired by the dotfiles community and tools like [Dotbot](https://github.com/anishathalye/dotbot) that simplify dotfile management.
