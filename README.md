highlight_notify
================

### high-level overview:

the server creates a [fifo pipe](https://duckduckgo.com/?q=mkfifo)  
when irssi detects that the fifo is there, it writes to it  
the server performs a blocking read on the fifo and sends it straight to the client  
the client forks to `notify-send`  
[dunst](http://www.knopwob.org/dunst/) displays a notification (because `notification-daemon` and `notify-osd` have fallen by the wayside with the advent of Gnome 3 shell built-in notifications)

### on the server:

```sh
cp highlight_notify.pl ~/.irssi/scripts
ln -s ~/.irssi/scripts/highlight_notify.pl ~/.irssi/scripts/autoload/highlight_notify.pl
aptitude install python3
nohup ./server.py &!
```

in irssi: `/script load highlight_notify.pl`

### on the client:

```sh
aptitude install dunst libnotify-bin
pip install sh
cp /usr/share/doc/dunst/dunstrc.example ~/.config/dunst/dunstrc
vi ~/.config/dunst/dunstrc
dunst &!
./client.py &!
aptitude purge notification-daemon notify-osd
```
