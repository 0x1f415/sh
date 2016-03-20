# oggify.sh

does a *uni-directional* sync between two directories, converting lossless audio formats to lossy ogg. smart enough to remove files that have been deleted/ignored since the first run. ignores any files in a folder (or subfolder of a folder) containing a `.no-oggify` file. should be okay to run as a cron job. useful for portable music players/phones.

this is **UNSUPPORTED AND NOT THOROUGHLY TESTED.** I am not responsible for loss of data! 

# stats.sh

lists load averages of local machine and a list of servers, or states if the server is down.

# status.sh

basic status script for i3bar. shows current track from DeaDBeeF and/or number of tasks from todo.sh.

# conkify.sh

exports variables containing either conky color codes if the first argument is "conky", or ANSI escape sequences otherwise. see `stats.sh` for an example.

incomplete, but you can easily extend for your own use.
