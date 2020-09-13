# homebrew-blame

External [Homebrew](https://github.com/Homebrew/brew) command for viewing `git blame` output for a formula or cask.

## Installation

```sh
brew tap rylan12/blame
```

## Usage

```sh
brew blame <formula|cask> [<revision>] [-L <line> | -L <start>,<end>]
```

Pass `-L` to choose which lines to annotate. `-L <line>` will annotate only the given line while `-L <start>,<end>` will annotate the range of lines from `<start>` to `<end>`. Leave `<start>` or `<end>` blank (keeping the comma) to annotate from the beginning of the file to `<end>` or from `<start>` to the end of the file respectively.

For example, `brew blame foo -L 16` will annotate only line 16 of `foo.rb` but `brew blame foo -L 16,` will annotate from line 16 to the end of `foo.rb`

A revision can also be passed as a second named argument. For example, `brew blame foo aad80774352^` will annotate `foo.rb` starting from the parent commit to `aad80774352`.
