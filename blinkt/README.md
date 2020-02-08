## blinkt

**blinkt/display-led.py** is a python script that displays the system information stored in a file, /usr/local/data/us-tx-cluster-1/<hostname>, on each system.  The system information is displayed using a Raspberry Pi with Pimoroni Blinkt.  The system
information includes cpu temperature in Celsius and Fahrenheit, the system load, memory usage, and disk usage.

blinkt/display-led-test.py is a python script that tests the leds during system boot.  They are configured using, crontab -e

#### If you like this repository, select in the upper-right corner, STAR, thank you.

## Install
To install the entire repository, change to the location you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have git then enter; "sudo apt-get install git" if using Ubuntu.  On the github page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/pi-display
    cd pi-display/blinkt/

#### WARNING: These instructions below are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!  Need to continue to organize the research from the many systems running different test cases.   Organize it into; what works, what I want, and what I still need to make this design work:
    
## Usage
    $ ./display-led.py 

## Output
    2019-01-23T21:32:14.832928-06:00 (CST) six-rpi3b.cptx86.com ./display-led.py[10517] 3.318.504 115 uadmin 10000:10000 [INFO]  Started...
    2019-01-23T21:32:20.898087-06:00 (CST) six-rpi3b.cptx86.com ./display-led.py[10517] 3.318.504 332 uadmin 10000:10000 [INFO]  Operation finished.
    
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

#### ARCHITECTURE TREE

#### System OS script tested
 * Ubuntu 16.04.3 LTS (armv7l)

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root
 * Be easy to install and configure

#### License
MIT License

Copyright (c) 2020  Bradley Allen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

