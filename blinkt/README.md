## blinkt

**blinkt/display-led.py** is a python script that displays the system information stored in a file, /usr/local/data/us-tx-cluster-1/<hostname>, on each system.  The system information is displayed using a Raspberry Pi with Pimoroni Blinkt.  The system
information includes cpu temperature in Celsius and Fahrenheit, the system load, memory usage, and disk usage.

blinkt/display-led-test.py is a python script that tests the leds during system boot.  They are configured using, crontab -e

#### If you like this repository, select in the upper-right corner, [![GitHub stars](https://img.shields.io/github/stars/BradleyA/pi-display.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/BradleyA/pi-display/stargazers/), thank you.
## Clone
To Install, change into a directory that you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have Git installed then enter; "sudo apt-get install git" if using Debian/Ubuntu. Other Linux distribution install methods can be found here: https://git-scm.com/download/linux. On the GitHub page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/pi-display
    cd pi-display/blinkt/

#### WARNING: These instructions below are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!  Need to continue to organize the research from the many systems running different test cases.   Organize it into; what works, what I want, and what I still need to make this design work:
<img id="Construction" src="../images/construction-icon.gif" width="120">

## Usage
    $ ./display-led.py 

## Output
    2019-01-23T21:32:14.832928-06:00 (CST) six-rpi3b.cptx86.com ./display-led.py[10517] 3.318.504 115 uadmin 10000:10000 [INFO]  Started...
    2019-01-23T21:32:20.898087-06:00 (CST) six-rpi3b.cptx86.com ./display-led.py[10517] 3.318.504 332 uadmin 10000:10000 [INFO]  Operation finished.

[Return to top](https://github.com/BradleyA/pi-display/tree/master/blinkt#blinkt)

## NOTES:
To view crontab changes for blinkt, crontab -l

To edit crontab and enter the following chnages, crontab -e
    
    #   Raspberry Pi with blinkt for pi-display
    #   Uncomment the following 7 lines on Raspberry Pi with blinkt installed for pi-display
    @reboot   /usr/local/bin/display-led-test.py >> /usr/local/data/us-tx-cluster-1/log/six-rpi3b.cptx86.com-crontab 2>&1
    * * * * *            /usr/local/bin/create-host-info.sh >> /usr/local/data/us-tx-cluster-1/log/six-rpi3b.cptx86.com-crontab 2>&1
    * * * * * sleep 5  ; /usr/local/bin/display-led.py >> /usr/local/data/us-tx-cluster-1/log/six-rpi3b.cptx86.com-crontab 2>&1
    * * * * * sleep 20 ; /usr/local/bin/create-host-info.sh >> /usr/local/data/us-tx-cluster-1/log/six-rpi3b.cptx86.com-crontab 2>&1
    * * * * * sleep 25 ; /usr/local/bin/display-led.py >> /usr/local/data/us-tx-cluster-1/log/six-rpi3b.cptx86.com-crontab 2>&1
    * * * * * sleep 40 ; /usr/local/bin/create-host-info.sh >> /usr/local/data/us-tx-cluster-1/log/six-rpi3b.cptx86.com-crontab 2>&1
    * * * * * sleep 45 ; /usr/local/bin/display-led.py >> /usr/local/data/us-tx-cluster-1/log/six-rpi3b.cptx86.com-crontab 2>&1
    #
    #   All Raspberry Pi's that include any above section to rotate logs for pi-display
    #   Uncomment the following line to rotate logs for pi-display
    6 */2 * * * /usr/sbin/logrotate -s /usr/local/data/us-tx-cluster-1/logrotate/status /usr/local/data/us-tx-cluster-1/logrotate/pi-display-logrotate >> /usr/local/data/us-tx-cluster-1/log/six-rpi3b.cptx86.com-crontab 2>&1

[Return to top](https://github.com/BradleyA/pi-display/tree/master/blinkt#blinkt)

#### ARCHITECTURE TREE

[Return to top](https://github.com/BradleyA/pi-display/tree/master/blinkt#blinkt)

----

#### Contribute
Please do contribute!  Issues, comments, and pull requests are welcome.  Thank you for your help improving software.

[Return to top](https://github.com/BradleyA/pi-display/tree/master/blinkt#blinkt)

#### Author
[<img id="github" src="../images/github.png" width="50" a="https://github.com/BradleyA/">](https://github.com/BradleyA/)    [<img src="../images/linkedin.png" style="max-width:100%;" >](https://www.linkedin.com/in/bradleyhallen) [<img id="twitter" src="../images/twitter.png" width="50" a="twitter.com/bradleyaustintx/">](https://twitter.com/bradleyaustintx/)       <a href="https://twitter.com/intent/follow?screen_name=bradleyaustintx"> <img src="https://img.shields.io/twitter/follow/bradleyaustintx.svg?label=Follow%20@bradleyaustintx" alt="Follow @bradleyaustintx" />    </a>          [![GitHub followers](https://img.shields.io/github/followers/BradleyA.svg?style=social&label=Follow&maxAge=2592000)](https://github.com/BradleyA?tab=followers)

[Return to top](https://github.com/BradleyA/pi-display/tree/master/blinkt#blinkt)

#### Tested OS
 * Ubuntu 14.04.6 LTS (amd64,armv7l)
 * Ubuntu 16.04.7 LTS (amd64,armv7l)
 * Ubuntu 18.04.5 LTS (amd64,armv7l)
 * Raspbian GNU/Linux 10 (buster)

[Return to top](https://github.com/BradleyA/pi-display/tree/master/blinkt#blinkt)

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root
 * Be easy to install and configure

[Return to top](https://github.com/BradleyA/pi-display/tree/master/blinkt#blinkt)

#### License
MIT License

Copyright (c) 2020  Bradley Allen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[Return to top](https://github.com/BradleyA/pi-display/tree/master/blinkt#blinkt)
