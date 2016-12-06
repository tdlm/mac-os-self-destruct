# macOS Self Destruct (Formerly OS X Self Destruct)
==================
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/tdlm/os-x-self-destruct?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

**Author**: [Scott Weaver](http://scottmw.com/)

**License**: GNU GPL v2.0 (see LICENSE.txt)

**Version**: 0.92

Securely destroys files or directories on a delay based on their OS X "Tag."

Available Tags: 1 Minute, 1 Hour, 1 Day, 1 Week, 1 Month, 1 Year.  
Multiplications of these tags are also supported (10 Minutes, 3 Hours, etc.).

For example, if a file is tagged with "1 Week" then it will be deleted at the time exactly one week from the last time the file was modified.

This allows you to put a self-destruct on files you would otherwise forget about, leaving your system crowded with junk.

### SYSTEM REQUIREMENTS
Tested to work on OS X 10.9, OS X 10.10

### HELP

```bash
./self-destruct.sh --help
```

#### INSTALLATION

```bash
git clone git@github.com:tdlm/mac-os-self-destruct.git
./mac-os-self-destruct/self-destruct.sh --install
```

#### USAGE

Once you have installed the cron process and it is actively working, you can start using self destruct immediately.

*Open Tags Option*

To get to the Tags area, right click on the file(s) you wish to tag and select "Tags..."

![Open Tags Menu](http://scottmw.com/wp-content/uploads/2014/09/tags-menu.png)

*Select Desired Tag*

Assign one of the available tags to the file (spelling/spacing is important, but the character case does not matter):

![Select Desired Tag](http://scottmw.com/wp-content/uploads/2014/09/tags-assign.png)

*Verify Tag*

You can verify the tag was placed on the file(s) by doing a simple search (e.g. "1 Day") and selecting the tags option.

![Search for Tag](http://scottmw.com/wp-content/uploads/2014/09/tags-search.png)

Once you've searched for the tag, you can see any files slated for self destruct.

![Verify Tag by Search](http://scottmw.com/wp-content/uploads/2014/09/1day-delete.png)

And now we wait.

### RUNNING MANUALLY

Run manually when installed:

```bash
self-destruct --run
```

Run manually when NOT installed:

```bash
./path/to/repo/self-destruct.sh --run
```

### Disclaimer

Although I have used this for months without a problem, using this means you are doing so at your own risk.
