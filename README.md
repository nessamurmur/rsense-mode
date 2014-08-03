## [RSense](https://github.com/rsense/rsense) mode for Emacs

RSense mode is a minor mode for emacs that provides the best autocomplete for Ruby in town.

### Installation

First clone this repo wherever you like

```
git clone https://github.com/niftyn8/rsense-mode ~/.emacs.d/rsense-mode
```

Next add it to your emacs load path and require rsense:

```lisp
(add-to-list 'load-path "~/.emacs.d/rsense-mod")
(require 'rsense)
```

Next install the rsense gem

```
gem install rsense
```

Once installation has completed run `rsense start` and you're good to go!

### Usage

As long as you've run `rsense start` simply open a .rb file and press tab to autocomplete!
