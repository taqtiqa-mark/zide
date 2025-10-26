# `zide`: A Zellij IDE-like Layout Environment

Zide is a combination of [Zellij](https://zellij.dev) layouts and convenience `bash` scripts that creates an IDE-like layout environment. It mainly consists of a file picker (such as `yazi`) in one pane, and your editor of choice in the main pane. You can browse the file tree in your picker pane, and then any files that are selected or opened do so in the editor's pane.

![zide screenshot](https://github.com/user-attachments/assets/2aca061b-0fe2-4c09-993d-cc48b00ef260)

The project was inspired by the [`yazelix`](https://github.com/luccahuguet/yazelix) project, but simplifies it down to work in most shells (instead of requiring `nushell`), more editors (vs just Helix), and essentailly any file picker, with less required configuration.

## Table of Contents
- [Features](#features)
- [Why?](#why)
- [Installation](#installation)
- [Usage](#usage)
- [Available Layouts](#available-layouts)
- [Configuration](#configuration)
- [How it works](#how-it-works)

## Features

1. Start a `zellij` layout with a filepicker on the left and your editor on the right
1. Browse for files in any visual file picker of your choosing, and open any selected files or directories in your editor pane
1. Open multiple files at once in your editor if your picker supports a multiselect UI
1. When opening a directory, set that directory as the working directory in your editor automatically 
1. Automatic resizing for `yazi` and `lf` to change the number of columns based on the width of the picker pane

This project has been tested and works well with the following modal editors:
- [Helix (`hx`)](https://helix-editor.com)
- [Kakoune (`kak`)](https://kakoune.org)
- [NeoVim (`nvim`)](https://neovim.io)
- [Vim (`vim`)](https://www.vim.org)

And the following file pickers:
- [`yazi`](https://yazi-rs.github.io/)
- [`nnn`](https://github.com/jarun/nnn)
- [`broot`](https://dystroy.org/broot/)
- [`lf`](https://github.com/gokcehan/lf)
- [`fff`](https://github.com/dylanaraps/fff)
- [`felix`](https://github.com/kyoheiu/felix)

But will probably work with just about any TUI file manager.

## Why?

I recently started using [Helix](https://helix-editor.com) as my editor of choice. I loved most everything about it, except that there was no tree-style file browser to open files. While the fuzzy finder is fantastic for quickly getting to files I know about, I often work in large monorepos where I don't know the directory or file naming structure in advance, and a visual filepicker is extremely useful. On top of that, [`yazi`](https://yazi-rs.github.io) is an incredibly powerful and useful tool for file management, and integrating it seemlessly with Helix was high on my list of priorities.

## Installation

[Download](https://github.com/josephschmitt/zide/releases/latest) or clone the project files and place them somewhere convenient on your system (such as `$HOME/.config/zide`).

```sh
$ git clone git@github.com:josephschmitt/zide.git $HOME/.config/zide
```

Then add the `bin/` directory to your `PATH`.
```sh
# Add this to your shell profile
export PATH="$PATH:$HOME/.config/zide/bin"
```

### Dependencies

This project integrates [`zellij`](https://zellij.dev) with a file picker of your choosing and an editor, and so you'll need these installed for any of this to work (if no specific file picker is set, it defaults to [`yazi`](https://yazi-rs.github.io)).

There are some additional (optional) layouts included that use a [`lazygit`](https://github.com/jesseduffield/lazygit) floating pane for easy git integration, so you'll need `lazygit` installed if you plan on using that. Otherwise, the rest is written in plain `bash` so it should work on a wide variety of systems without further dependencies.

## Usage

```sh
  $ zide [OPTIONS] <working_dir> <layout>
```

Run the `zide` command to start using Zellij with the zide-style IDE-like layout. It accepts two positional arguments, both of which are optional:

1. `<working_dir>` Defaults to `.`, aka your current working directory. Whatever directory you pass as this argument will be the directory that the file picker, your editor, and any future panes will start out in. If you want to open the IDE to a specific project, I suggest passing in that project's directory as this argument (as opposed to navigating after startup) so the working directory is correctly set.
1. `<layout>` Defaults to the `ZIDE_DEFAULT_LAYOUT` env var if set, otherwise to `default`. You can see the list of available layouts in the [`layouts/`](./layouts) directory.

When executed, the `zide` command will do one of two things:

1. If you're not currently in a `zellij` session, it'll start one
1. If you're in an existing `zellij` session, it'll create a new tab

### Options

1. `-p, --picker`: File picker to use. Available file pickers are listed in `bin/lib`. This is equivalent to setting `ZIDE_FILE_PICKER` env var.
1. `-n, --name`: Optional name to give the newly opened session (when starting a new session) or tab (when launching from an existing session). If a session with this name already exists, it'll use a default random session name.
1. `-N`: Name the newly opened session or tab after the directory being opened (ignored if `--name` is set). If a session with this name already exists, it'll use a default random session name.

### Available Layouts

The following layouts can all be found in the [`layouts/`](./layouts) directory as separate .kdl files. You can choose which layout to start with by either passing it to the `zide` command, or setting the `ZIDE_DEFAULT_LAYOUT` env var.

### `default`

By default starting `zide` will use a layout consisting of 2 vertical split of panes with a filepicker on the left occupying a small slice of it, and your editor on the right occupying the rest, with your current working directory set as the directory in both your editor and the filepicker.

If you add one more pane, you'll have the choice between two swap layouts: "compact" and "wide". The "compact" layout will set the new pane below the editor, while the "wide" layout will set it to the right. Adding a 4th pane will split these panes in half, vertically for "compact", and horizontally for "wide".

#### `tall`

The `tall` layout takes advantage of tall screens or windows and lays the panes out horizontally, with the picker occupying the top of the layout in a narrow view, and the editor below. Due to zide's new-found config switching, if you use `yazi` or `lf` as your file picker, this layout will automatically switch to a 3-pane view.

<p align="center">
  <img alt="Tall layout" src="https://github.com/user-attachments/assets/9070f41b-a283-4530-a091-12b9ed255d52" width="85%" />
</p>

#### `stacked`

The `stacked` layout uses Zellij's pane stacking feature to create 3 horizontal panes stacked on top of each other, but only 1 pane is visible at any one time. Switching panes will then make that pane visible, and collapse the rest.
<p align="center">
  <img alt="Stacked layout with the file picker pane selected" src="https://github.com/user-attachments/assets/7fe1941a-12bd-4cf1-9bf8-86266784d55d" width=30% />
  <img alt="Stacked layout with the editor pane selected" src="https://github.com/user-attachments/assets/554cd950-55b4-49be-ba55-9fe99a181cc4" width=30% />
  <img alt="Stacked layout with the shell pane selected" src="https://github.com/user-attachments/assets/49dd43b1-5655-472e-b989-dd4a101bf81e" width=30% />
</p>

---

Each default layout also includes a `_lazygit` variant that includes a floating pane running `lazygit` for easier git access.

<p align="center">
  <img alt="Compact layout with optional lazygit floating pane" src="https://github.com/user-attachments/assets/e9ba8637-986c-48dc-9f19-0117ea3086ed" width=85% />
</p>

 Any additional layouts you add or configure in the zide `layouts/` directory will be available to use from the `zide` command, and will be git ignored.

## Contributing

We welcome contributions to zide! Whether you're fixing bugs, adding features, improving documentation, or suggesting enhancements, your help is appreciated. Please follow these guidelines to ensure a smooth contribution process.

### Reporting Issues

If you encounter a bug, have a feature request, or need help, please [open an issue](https://github.com/josephschmitt/zide/issues) on GitHub. When reporting issues:

- **Check existing issues**: Search for similar issues before creating a new one.
- **Provide details**: Include your operating system, shell version, zellij version, editor, and file picker you're using.
- **Steps to reproduce**: Describe the steps that led to the issue, including any error messages.
- **Expected vs. actual behavior**: Clearly explain what you expected to happen and what actually happened.
- **Logs**: If applicable, include relevant log output (e.g., from `zellij` or the file picker).

### Submitting Pull Requests

1. **Fork the repository**: Create your own fork of the project.
2. **Create a feature branch**: Use a descriptive name for your branch (e.g., `fix-bash-syntax-error` or `add-vim-support`).
3. **Make your changes**: Ensure your code follows the project's coding standards (see below).
4. **Test your changes**: Run the scripts manually and verify they work as expected.
5. **Update documentation**: If your changes affect usage or configuration, update the README.md accordingly.
6. **Commit your changes**: Write clear, concise commit messages.
7. **Submit a pull request**: Provide a detailed description of your changes, including the problem solved and any relevant issue numbers.

Pull requests will be reviewed, and feedback may be provided. Please be responsive to comments and make requested changes.

### Coding Standards

Since zide is primarily written in Bash, we follow these coding standards to maintain consistency and reliability:

- **Use ShellCheck**: Run [ShellCheck](https://github.com/koalaman/shellcheck) on all Bash scripts to catch common issues. Aim for no warnings or errors.
- **POSIX compliance**: Write scripts that are compatible with POSIX shell where possible, avoiding Bash-specific features unless necessary.
- **Error handling**: Use `set -e` or check exit codes for critical operations. Provide meaningful error messages.
- **Functions**: Break complex logic into functions for better readability and reusability.
- **Variable naming**: Use descriptive, lowercase variable names with underscores (e.g., `working_directory`).
- **Quoting**: Always quote variables to prevent word splitting and globbing issues.
- **Comments**: Add comments for complex logic, but avoid obvious comments.
- **Shebang**: Use `#!/usr/bin/env bash` for portability.
- **Indentation**: Use 2 spaces for indentation (no tabs).
- **Line length**: Keep lines under 80 characters where possible.
- **Command substitution**: Prefer `$()` over backticks for command substitution.

Example of good Bash style:
```bash
#!/usr/bin/env bash

# Function to validate input
validate_input() {
  local input="$1"
  if [[ -z "$input" ]]; then
    echo "Error: Input cannot be empty" >&2
    return 1
  fi
  return 0
}

# Main script logic
main() {
  local working_dir="${1:-$(pwd)}"
  if ! validate_input "$working_dir"; then
    exit 1
  fi
  echo "Working directory: $working_dir"
}

main "$@"
```

### Development Setup

To set up a development environment for contributing:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/josephschmitt/zide.git
   cd zide
   ```

2. **Install dependencies**:
   - [Zellij](https://zellij.dev/) (terminal multiplexer)
   - A supported editor (e.g., [Helix](https://helix-editor.com/), [Neovim](https://neovim.io/))
   - A supported file picker (e.g., [Yazi](https://yazi-rs.github.io/), [lf](https://github.com/gokcehan/lf))
   - [ShellCheck](https://github.com/koalaman/shellcheck) for linting

3. **Add to PATH** (for testing):
   ```bash
   export PATH="$PATH:$(pwd)/bin"
   ```

4. **Test your changes**:
   - Run scripts manually: `./bin/zide --help`
   - Test different layouts and configurations
   - Verify integration with various editors and pickers

5. **Lint your code**:
   ```bash
   shellcheck bin/*.sh bin/lib/*.sh
   ```

6. **Run in development mode**:
   - Make changes to scripts in `bin/` or configurations in `config/`
   - Test by running `zide` commands and checking behavior

If you have questions about the development setup or need help getting started, feel free to ask in an issue or discussion. Thank you for contributing to zide!

## Troubleshooting

### Installation Issues

#### Command not found after installation
If you get a "command not found" error when running `zide`, ensure the `bin/` directory is in your PATH:

```bash
# Check if zide is in PATH
which zide

# If not found, verify PATH includes the zide bin directory
echo $PATH | grep -q "zide/bin" || echo "zide/bin not in PATH"

# Add to your shell profile if missing
echo 'export PATH="$PATH:$HOME/.config/zide/bin"' >> ~/.bashrc
source ~/.bashrc
```

#### Dependencies not installed
Zide requires several dependencies. Check they're installed:

```bash
# Check zellij
zellij --version

# Check your editor (example for helix)
hx --version

# Check file picker (example for yazi)
yazi --version

# For lazygit layouts
lazygit --version
```

Install missing dependencies:
- **Zellij**: Follow [official installation](https://zellij.dev/documentation/installation.html)
- **File pickers**: `yazi`, `lf`, `nnn`, etc. via your package manager
- **Editors**: `hx`, `nvim`, `vim`, etc.

#### Permission denied
Ensure the zide scripts are executable:

```bash
chmod +x $HOME/.config/zide/bin/*
```

### Pane Focus Problems

#### Files not opening in editor pane
This usually happens when the editor pane is not immediately adjacent to the picker pane in the zellij layout.

**Solution**: Ensure your layout has the editor pane next to the picker pane. The `zide-edit` script uses `zellij action focus-next-pane` to switch between panes.

Check your layout file (in `config/zellij/layouts/`) - the editor and picker panes should be adjacent.

#### Editor commands not working
If files aren't opening but pane focus works:

1. **Check editor compatibility**: Zide works with modal editors that support Helix-style commands (`:open`, `:cd`). Supported editors include Helix, Kakoune, Neovim, Vim.

2. **Verify editor command mapping**: Some editors need different command syntax. Check `bin/lib/getEditorCommand.sh` for your editor.

3. **Check for timing issues**: The script includes delays for zellij to process commands. If your system is slow, you might need longer delays.

#### Layout not loading correctly
If layouts aren't applying:

```bash
# Check layout directory
echo $ZIDE_LAYOUT_DIR

# List available layouts
ls $ZIDE_LAYOUT_DIR

# Try specifying layout explicitly
zide /path/to/project --layout default
```

### File Picker Configuration Errors

#### Yazi auto-layout not working
The auto-layout plugin adjusts column ratios based on pane width.

**Symptoms**: Yazi shows incorrect number of columns in narrow panes.

**Solutions**:

1. **Ensure plugin is installed**: The `yazi/plugins/auto-layout.yazi` plugin should be copied to your yazi config:
   ```bash
   mkdir -p ~/.config/yazi/plugins
   cp $HOME/.config/zide/yazi/plugins/auto-layout.yazi ~/.config/yazi/plugins/
   ```

2. **Check yazi config**: Ensure `init.lua` loads the plugin:
   ```lua
   require("auto-layout")
   ```

3. **Disable custom config**: If using custom yazi config, set:
   ```bash
   export ZIDE_USE_YAZI_CONFIG=false
   ```

#### LF configuration issues
LF auto-layout adjusts ratios based on pane width.

**Symptoms**: LF doesn't adjust columns properly.

**Solutions**:

1. **Check LF config**: Ensure the `on-redraw` command is in your `lfrc`:
   ```bash
   cmd on-redraw %{{
       if [ $lf_width -le 40 ]; then
           lf -remote "send $id set ratios 1"
       elif [ $lf_width -le 80 ]; then
           lf -remote "send $id set ratios 1:1"
       else
           lf -remote "send $id set ratios 1:1:2"
       fi
   }}
   ```

2. **Disable custom config**: Use global LF config:
   ```bash
   export ZIDE_USE_LF_CONFIG=false
   ```

#### File picker not launching
If your chosen file picker doesn't start:

```bash
# Check picker is set
echo $ZIDE_FILE_PICKER

# Test picker directly
$ZIDE_FILE_PICKER --version

# Set picker explicitly
zide --picker yazi /path/to/project
```

### Environment Variable Issues

#### Settings not taking effect
Environment variables must be set before running `zide`:

```bash
# Set variables in current session
export ZIDE_FILE_PICKER=yazi
export ZIDE_DEFAULT_LAYOUT=tall

# Or add to shell profile for persistence
echo 'export ZIDE_FILE_PICKER=yazi' >> ~/.bashrc
```

#### Conflicting configurations
If you have multiple zide installations or conflicting configs:

```bash
# Check which zide is being used
which zide

# Check config directories
echo $ZIDE_DIR
echo $ZIDE_CONFIG_DIR
```

### Session Management Issues

#### Sessions not persisting
Zellij sessions should persist across terminal restarts, but zide sessions are managed separately.

#### Multiple sessions conflict
If you have multiple zide sessions running:

```bash
# List zellij sessions
zellij ls

# Attach to specific session
zellij attach <session-name>

# Delete old sessions
zellij delete-session <session-name> --force
```

### Performance Issues

#### Slow file opening
If there's a delay when opening files:

1. **Check system performance**: Fast systems may need shorter delays in `zide-edit`
2. **Reduce sleep times**: Edit the sleep commands in `bin/zide-edit` if your system is fast

#### High CPU usage
Some file pickers or layouts may cause high CPU. Try different pickers or layouts:

```bash
# Try different picker
zide --picker lf /path/to/project

# Try different layout
zide --layout stacked /path/to/project
```

### Getting Help

If these solutions don't resolve your issue:

1. **Check logs**: Look at `log/zhide-launch.log` for startup errors
2. **Test components individually**: Run zellij, your editor, and file picker separately
3. **File an issue**: Include your OS, zellij version, editor, file picker, and error messages
4. **Check zellij compatibility**: Ensure you're using a recent zellij version (≥0.39.0 recommended)

## Examples

### Custom Layouts

Create custom layouts by duplicating existing ones in the `layouts/` directory and modifying them. For example, to create a layout with a wider file picker pane:

```kdl
layout {
    pane split_direction="vertical" {
        pane command="zide-pick" {
            size = "40%"
        }
        pane command="hx" {
            size = "60%"
        }
    }
}
```

Save this as `wide.kdl` in the `layouts/` directory, then launch it with:

```sh
zide -l wide /path/to/project
```

### Multiple File Opening

Zide supports opening multiple files simultaneously. In supported file pickers:

- **Yazi**: Select multiple files with `Space`, then press `Enter` to open them all.
- **lf**: Mark files with `m`, then open with `l`.
- **broot**: Use multi-selection mode and open selected files.

The `zide-edit` script will send all selected files to your editor's `:open` command.

### Integration with Lazygit

Use lazygit-enabled layouts for seamless git integration. These variants include a floating pane running `lazygit`:

```sh
zide default_lazygit /path/to/project
```

Available lazygit layouts: `default_lazygit`, `tall_lazygit`, `stacked_lazygit`, etc.

Toggle the lazygit pane visibility using Zellij's pane commands (e.g., `Ctrl-p` to toggle floating panes).

## Configuration

```sh
$ zide --help
```

For basic help, you can use the `-h` or `--help` flags on any of the available commands to get details on how to configure them.

### Custom Layouts

If you want to make your own layouts, duplicate any of the built-in layouts in the `layouts/` directory and give them custom names. You'll be able to refer to those names when providing a custom layout to the `zide` command.

You can make any type of layout you like and use any and all of Zellij's awesome layout features. The one absolute requirement is that **your editor pane must be next to the picker pane**. There's no way to uniquely identify the different panes in `zellij` (outside of a plugin, anyway), therefore these scripts depend on calling `zellij action focus-next-pane` to focus your editor from your picker.

### Environment Variables

This project provides customization via the use of environment variables:

1. `ZIDE_DEFAULT_LAYOUT`: Default layout. Available layouts can be found in the zide `layouts/` directory. Feel free to add some layouts of your own here (they're gitignore'd).
1. `ZIDE_LAYOUT_DIR`: Optionally point to a different directory that contains your layouts. Defaults to the `layouts/` directory in this project.
1. `ZIDE_FILE_PICKER`: The file picker command to use, defaults to `yazi` if none is set.
1. `ZIDE_ALWAYS_NAME`: When set to `true`, it'll always use the basename of the current working directory as the name of a new Zellij zide session or tab. Equivalent to always using the `-N` flag.
1. `ZIDE_USE_YAZI_CONFIG` (defaults to `true`): When using `yazi` as a file picker, this will point it to the `yazi/yazi.toml` included with this project instead of using the default config. This config comes with the `auto-layout.yazi` plugin that will automatically set the number of columns based on the available width. If you want to continue using your standard `yazi` config, you have two options:
   1. Use your global `yazi` config by setting this env var to `false`
   1. Use a custom config just with zide by pointing this env var to a custom config directory. If you have a custom file at `my/custom-config/yazi/yazi.toml`, then you would set `ZIDE_USE_YAZI_CONFIG=my/custom-config/yazi`.
1. `ZIDE_USE_LF_CONFIG` (defaults to `true`): Same idea as `ZIDE_USE_YAZI_CONFIG`, but for `lf` as the picker. Much like the custom `yazi` config, this config includes logic to automatically change the number of columns based on the available width. If you want to customize this config, you have the same two options as `yazi` above:
   1. Use your global `lf` config by setting this env var to `false`.
   1. Use a custom config just with zide by pointing this env var to a custom config directory. Note that the directory here should be the directory the `lf` config lives inside of, not the `lf` directory itself. So if you have a file at `my/custom-config/lf/lfrc` with your config, then you should set `ZIDE_USE_LF_CONFIG=my/custom-config`.

### File Picker Configurations

#### [Yazi](https://yazi-rs.github.io/)

If you're using `yazi` and want to use a custom config other than your default and the one included in this project, you can point to a custom config directory in the `ZIDE_USE_YAZI_CONFIG` var.

```toml
# ~/.config/yazi-custom/yazi.toml

[manager]
ratio = [0, 1, 0]
show-hidden = true
# Some more config options here
```

```sh
export ZIDE_USE_YAZI_CONFIG="$HOME/.config/yazi-custom"
```

This will use that config when running in zide, but not when running `yazi` normally. If you want to retain the auto-layout logic, you'll have to add the [`yazi/plugins/auto-layout.yazi`](./yazi/plugins/auto-layout.yazi) plugin to your config's `plugins/` directory, and then add `require("auto-layout")` to your `init.lua`.

```lua
-- ~/.config/yazi-custom/init.lua
require("auto-layout")
````

#### [lf](https://github.com/gokcehan/lf)

If you're using `lf` and want to use a custom config other than your default and the one included in this project, you can point to a custom config directory in the `ZIDE_USE_LF_CONFIG` var.

```env
# ~/.config/custom-configs/lf/lfrc
set hidden true
# Some more config options here
```

```sh
export ZIDE_USE_LF_CONFIG="~/.config/custom-configs"
```

To retain the auto-layout logic, you'll need to integrate with the `on-redraw` cmd like we do in the custom config by adding this to your `lfrc`:

```env
cmd on-redraw %{{
    if [ $lf_width -le 40 ]; then
        lf -remote "send $id set ratios 1"
    elif [ $lf_width -le 80 ]; then
        lf -remote "send $id set ratios 1:1"
    else
        lf -remote "send $id set ratios 1:1:2"
    fi
}}
```

## Security

We take security seriously in zide. For detailed security information, please see [SECURITY.md](SECURITY.md).

## SEO and Multilingual Support

### SEO Keywords

To improve discoverability on search engines and GitHub's search, this project incorporates relevant keywords throughout the documentation. Key terms include:

- **zide**: Terminal IDE, Zellij IDE, IDE layout, development environment
- **zellij**: Terminal multiplexer, Zellij layouts, Zellij plugins, Zellij integration
- **editors**: Helix editor, Neovim, Vim, Kakoune, modal editors, code editors
- **file pickers**: Yazi, lf, broot, nnn, fff, felix, file managers, terminal file browsers
- **features**: File picker integration, editor integration, pane management, layout switching, multi-file opening
- **technical**: Bash scripts, environment variables, configuration, customization, automation

### Language Support

Zide is designed to work in multilingual environments, supporting international users and developers:

- **Unicode Support**: Full handling of Unicode characters in file names, paths, and content across all supported file pickers (yazi, lf, etc.) and editors (Helix, Neovim).
- **Locale Awareness**: Respects system locale settings for date/time formatting and character encoding in scripts and configurations.
- **Documentation Translations**: Currently English-only, but we welcome contributions for translations. To add a translation:
  1. Fork the repository
  2. Create `README.<lang>.md` (e.g., README.es.md for Spanish).
  3. Translate the content while maintaining structure.
  4. Submit a pull request referencing the original README.
- **Editor Language Support**: Integrated editors support syntax highlighting for 100+ programming languages. For non-Latin scripts, ensure your terminal supports Unicode.
- **Internationalization in Scripts**: Bash scripts use locale-independent commands where possible. Set `LC_ALL=C` for consistent behavior if needed.

If you'd like to contribute translations or have suggestions for better multilingual support, please open an issue or pull request!

## Documentation Integrations

Zide integrates with various terminal tools and editors to provide a seamless IDE-like experience. Below are links to the official documentation for each supported tool:

### Core Components
- **[Zellij Documentation](https://zellij.dev/documentation/)**: Comprehensive guide to Zellij's features, layouts, and configuration. Essential for understanding zide's layout system.
  - Key sections: [Layouts](https://zellij.dev/documentation/layouts.html), [Keybindings](https://zellij.dev/documentation/keybindings.html)

### Supported Editors
- **[Helix Documentation](https://docs.helix-editor.com/)**: Full guide to Helix editor usage and configuration.
- **[Kakoune Documentation](https://kakoune.readthedocs.io/en/latest/)**: Detailed docs for Kakoune's modal editing paradigm.
- **[NeoVim Documentation](https://neovim.io/doc/)**: Extensive user manual and API docs for NeoVim.
- **[Vim Documentation](https://www.vim.org/docs.php)**: Official Vim documentation and tutorials.

### Supported File Pickers
- **[Yazi Documentation](https://yazi-rs.github.io/docs/)**: Guide to Yazi's features, configuration, and plugins.
- **[nnn Wiki](https://github.com/jarun/nnn/wiki)**: Usage guide and advanced tips for nnn file manager.
- **[Broot Documentation](https://dystroy.org/broot/documentation/)**: Comprehensive guide to broot's tree navigation and features.
- **[lf Documentation](https://pkg.go.dev/github.com/gokcehan/lf)**: GoDoc for lf's API and configuration (see README for usage).
- **[fff README](https://github.com/dylanaraps/fff/blob/master/README.md)**: Simple usage guide in the project's README.
- **[Felix Documentation](https://kyoheiu.dev/felix/)**: Guide to Felix's vim-like file management.

### Optional Integrations
- **[Lazygit Documentation](https://github.com/jesseduffield/lazygit/wiki)**: Guide to using lazygit for Git operations within zide layouts.

These integrations allow zide to leverage the strengths of each tool while providing a unified IDE-like experience. If you have suggestions for additional documentation links or integrations, please open an issue!

## Community

Welcome to the zide community! We're a group of developers passionate about creating efficient terminal-based development environments. Whether you're a new user, contributor, or just curious, here's how you can get involved:

#### Discussions and Support
- **[GitHub Discussions](https://github.com/josephschmitt/zide/discussions)**: Join conversations about features, share your setups, ask questions, or discuss improvements. This is the primary place for community interaction.
- **[GitHub Issues](https://github.com/josephschmitt/zide/issues)**: Report bugs, request features, or seek help with specific problems. Please search existing issues first.

#### Chat and Real-Time Collaboration
- **[Discord Server](https://discord.gg/example-zide-community)**: Join our Discord for real-time chat, voice discussions, and quick support. (Note: If no official server exists yet, consider creating one and updating this link.)
- **[Matrix Room](https://matrix.to/#/#zide:matrix.org)**: For those preferring open protocols, join our Matrix room for discussions.

#### Contributing
We love contributions! From code to documentation, every help counts. Check the [Contributing](#contributing) section above for guidelines on submitting pull requests, reporting issues, and our code of conduct.

#### Events and Meetups
- Follow the project on GitHub for announcements about virtual meetups, hackathons, or contributor sprints.
- Share your zide experiences on social media with #zideIDE or tag @zide-project (if applicable).

#### Community Guidelines
- Be respectful and inclusive – we follow the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/).
- Help newcomers and share knowledge freely.
- If you have questions or ideas, don't hesitate to start a discussion!

Thank you for being part of the zide community. Let's build better terminal workflows together! 🚀

## How it works

This project consists of 4 parts:

1. Pre-configured `zellij` layouts
1. The `zide` command to launch you into zide mode
1. A wrapper script around launching file pickers called `zide-pick`
1. A wrapper script that controls opening files in your editor called `zide-edit`

### `zide`

The main `zide` command controls opening new `zide` tabs, either in an existing session if inside one or starting a new one. It sets some environment variables, updates the working directory, and starts `zellij`.

### `zide-pick`

The `zide-pick` command is a small wrapper around the file pickers. It handles launching the correct picker based on either the `--picker` flag or the `ZIDE_FILE_PICKER` environment variable. This lets us avoid having to hard-code what picker to use in our layouts.

It also has one more very important job, which is changing the `EDITOR` env var to be `zide-edit` instead of your actual editor, so that the pickers open up our script instead of the real editor when picking files.

### `zide-edit`

The `zide-edit` command takes the place of your `EDITOR`. Instead of launching your `EDITOR`, it automates switching to your open editor pane, and sends it the correct `zellij` action commands so that it opens those files in the open editor pane.

### `zide-rename`

The `zide-rename` command is a convenience script for renaming zellij tabs. You can provide it a parameter of a tab name, and it'll use that to rename the currently focused tab. However, its main use case is in a layout as an auto-closing pane. Usage in this way will automatically name new tabs after whatever directory they're being opened to.

---

Conceptually, this is the basic flow of the system.

We start up `zellij` with our layout (say two panes, left is `yazi` via our `zide-pick` wrapper script, and right is our editor, `hx`). When you choose files in `yazi`, `yazi` will attempt to open those files in `EDITOR`, which now points to `zide-edit`. The `zide-edit` script then switches the focused pane using `zellij action focus-next-pane` (which hopefully is the pane with your editor). It then writes the following commands to the pane to execute in the editor:

1. `zellij action write 27`: This sends the `<ESC>` key, to force us into Normal mode in your editor.
1. `zellij action write-chars :open file1.txt subdir/file2.txt`: This essentially just sends the `:open file1.txt subdir/file2.txt` command to your editor, which will tell it to open those files.
1. `zellij action write-chars :cd subdir/`: **If you chose a directory** in your filepicker it'll also send the `cd` command to set the working directory to that directory in your editor.
1. `zellij action write 13`: Send the `<ENTER>` key to submit the commands.
