## blinkt
#### WARNING: These instructions are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!
Need to continue to organize the research from the many systems running different test cases.   Organize it into; what works, what I want, and what I still need to make this design work:
    
#### Clone
To clone the entire repository, change to the location you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have git then enter; "sudo apt-get install git". On the github page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/pi-display
    cd pi-display/blinkt/

#### Install
To install, change to the directory, cd /usr/local/bin, to download the script.

    curl -L https://api.github.com/repos/BradleyA/pi-display/tarball | tar -xzf - --wildcards *blinkt/xxxx ; mv BradleyA-pi-display-*/blinkt/xxxx.sh . ; rm -rf BradleyA-pi-display-*

#### Usage
    xxxx 

#### Output
    $ xxxx
    
#### NOTES:
LED 7 report CPU temperature
        LED_number = 7
        if   VALUE < 48.5 : # < 48.5 C 119.3  1
            status1(LED_number)
        elif VALUE < 59   : # < 59 C   138.2  2
            status2(LED_number)
        elif VALUE < 69.5 : # < 69.5 C 157.1  3
            status3(LED_number)
        elif VALUE < 80   : # < 80 C   176    4
            status4(LED_number)
        elif VALUE >= 80  :   # > 80 C 176    5
            status5(LED_number):

#### System OS script tested
 * Ubuntu 14.04.3 LTS
 * Ubuntu 16.04.3 LTS (armv7l)

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root
 * Be easy to install and configure

#### License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
