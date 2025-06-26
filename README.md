# nvim-config
My NVIM `init.vim` file and global command for quickly opening it from anywhere.

# Installation
1. Clone the repository.
2. Copy the `init.vim` file to your NVIM configuration directory, typically `~/.config/nvim/init.vim`.
3. Add the global command to your shell configuration file (e.g., `.bashrc`, `.zshrc`):
   ```bash
   alias nvim-config='nvim ~/.config/nvim/init.vim'
   ```
4. Reload your shell configuration file or restart your terminal.

# Key Bindings
- `nvim .` to open the current directory in NVIM.
- `SPACE + T` (Then I) to open the terminal.
- `SPACE + up or down arrow` to resize terminal.
- `SPACE + f` to open the file explorer.
- `SPACE + left or right arrow` to rize side bar.

# Useful Go Commands
`GoTestFile` command is used to run tests in the current file. It uses `go test` command and `go test -v` for verbose output. It also uses `go test -run` to run a specific test function.
