# dotfiles
**link refs:** 
- [Dotfiles with a bare git repository](https://www.atlassian.com/git/tutorials/dotfiles)
- [What is a bare git repository?](https://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/)

## Installing on a new system
### Cloning dotfiles
- Clone dotfiles into bare repository in "dot" folder of `$HOME`
```
git clone --bare git@github.com:lucasdu2/dotfiles.git $HOME/.cfg
```
- Define "config" alias in current shell scope
```
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```
- Checkout the actual content of bare repository to your `$HOME`
```
cd $HOME
config checkout
```
- Set flag `showUntrackedFiles` to `no` in our new local repository
```
config config --local status.showUntrackedFiles no
```
### Additional setup
- Ensure necessary programs/packages are installed and up-to-date:
    - neovim (text editor)
    - zsh (shell)
    - starship (shell prompt) 
    - fzf
    - ripgrep
- fzf comes with some nice shell extensions for zsh that require additional installation. See [here](https://github.com/junegunn/fzf#installation).
- Open neovim (can simply use vi, the alias is defined in .zshrc) and install all plugins using `:PlugInstall.`
    - We manage plugins using [vim-plug](https://github.com/junegunn/vim-plug). 
    - We have configured automatic installation of vim-plug (see init.vim). However, if `:PlugInstall` does not work, you may need to install vim-plug manually. 
- Also in neovim, run `:TSUpdate` to ensure all nvim-treesitter plugin (syntax highlighting) parsers are up-to-date. 
    - This should already be done automatically by our vim-plug configuration, but it's good to make sure.
#### Language-specific configuration
These dotfiles also include language-specific tooling. Most should be handled by neovim's built-in LSP client.
- Go
    - We currently use [vim-go](https://github.com/fatih/vim-go) for Go tooling (not neovim's built-in LSP client). 
    - If Go binaries are not yet installed on the system, vim-go provides a command, `:GoInstallBinaries`, to install all required binaries.
- Python
    - Install [pyright](https://github.com/microsoft/pyright)
- C
    - Install [clangd](https://clangd.llvm.org/installation.html)
    - clangd relies on a JSON compilation database, specified as compile_commands.json (see [here](https://clangd.llvm.org/installation#compile_commandsjson))
    - One way to generate this database is to use [bear](https://github.com/rizsotto/Bear)

