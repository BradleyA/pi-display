# pi-display
[![GitHub Stable Release](https://img.shields.io/badge/Release-3.403-blue.svg)](https://github.com/BradleyA/pi-display/releases/tag/3.403)
![GitHub Release Date](https://img.shields.io/github/release-date/BradleyA/pi-display?color=blue)
[![GitHub Commits Since](https://img.shields.io/github/commits-since/BradleyA/pi-display/3.403?color=orange)](https://github.com/BradleyA/pi-display/commits/)
[![GitHub Last Commits](https://img.shields.io/github/last-commit/BradleyA/pi-display.svg)](https://github.com/BradleyA/pi-display/commits/)

[![GitHub Open Issues](https://img.shields.io/github/issues/BradleyA/pi-display?color=purple)](https://github.com/BradleyA/pi-display/issues?q=is%3Aopen+is%3Aissue)
[![GitHub Closed Issues](https://img.shields.io/github/issues-closed/BradleyA/pi-display?color=purple)](https://github.com/BradleyA/pi-display/issues?q=is%3Aclosed+is%3Aissue)
[<img alt="GitHub Clones" src="https://img.shields.io/static/v1?label=Clones&message=89&color=blueviolet">](https://github.com/BradleyA/pi-display/blob/master/images/clone.table.md)
[<img alt="GitHub Views" src="https://img.shields.io/static/v1?label=Views&message=327&color=blueviolet">](https://github.com/BradleyA/pi-display/blob/master/images/view.table.md)
[![GitHub Size](https://img.shields.io/github/repo-size/BradleyA/pi-display.svg)](https://github.com/BradleyA/pi-display/)
![Language Bash Python](https://img.shields.io/badge/%20Language-bash/python-blue.svg)
[![MIT License](http://img.shields.io/badge/License-MIT-blue.png)](LICENSE)

----

This repository contains shell scripts and python for RaspBerry Pi display project.  The displays are Pimoroni Blinkt, Scroll-pHAT, and Scroll-pHAT-HD connected to Raspberry Pi 3 using Triple GPIO Multiplexing Expansion Board. 

#### If you like this repository, select in the upper-right corner, star, thank you.

 <img id="image_respberry_scroll-phat" src="images/IMG_3247.JPG" width="450" >

----> ![Click this link, then click 'view raw' to see board running](images/IMG_3246.MOV)

 * [scrollphat](https://github.com/BradleyA/pi-display/tree/master/scrollphat) 
 * [scrollphathd](https://github.com/BradleyA/pi-display/tree/master/scrollphathd)
 * [blinkt](https://github.com/BradleyA/pi-display-board/tree/master/blinkt)
 
## Architecture

<img id="pi-display architecture" src="images/pi-display-architecture.png" width="900" >
 
<img id="image_respberry_setup" src="images/IMG_2803.JPG" width="450" >

#### WARNING: These instructions below are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!  I need to get this to work and completed then some cleanup before it is shareable and documented . . .

## Install

To install, change directory to the location you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have git then enter; "sudo apt-get install git" if using Ubuntu. On the github page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/pi-display
    cd pi-display
    
Install Docker


  
#### Author
[<img id="github" src="images/github.png" width="50" a="https://github.com/BradleyA/">](https://github.com/BradleyA/)    [<img src="images/linkedin.png" style="max-width:100%;" >](https://www.linkedin.com/in/bradleyhallen) [<img id="twitter" src="images/twitter.png" width="50" a="twitter.com/bradleyaustintx/">](https://twitter.com/bradleyaustintx/)       <a href="https://twitter.com/intent/follow?screen_name=bradleyaustintx"> <img src="https://img.shields.io/twitter/follow/bradleyaustintx.svg?label=Follow%20@bradleyaustintx" alt="Follow @bradleyaustintx" />    </a>

#### System OS script tested

 * Ubuntu 16.04.3-5 LTS (armv7l)

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root
 * Be easy to install and configure
 
#### To watch future updates in this repository select in the upper-right corner, the "Watch" list, and select Watching.

#### License
MIT License

Copyright (c) 2020 [Bradley Allen](https://www.linkedin.com/in/bradleyhallen)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
