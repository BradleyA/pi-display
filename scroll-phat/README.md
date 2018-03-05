

#### WARNING: These instructions are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!

#### To watch future updates in this repository select in the upper-right corner, the "Watch" list, and select Watching. 

create-message.sh - This script stores Docker information about containers and images in a file on each system in a cluster.  These files are copied to all host and totaled in a file, /usr/local/data/<cluster-name>/MESSAGE.  The MESSAGE file includes
the total number of containers, running containers, paused containers, stopped containers, and number of images.  The MESSAGE file is used by a Raspberry Pi Scroll-pHAT to display the information.

This script reads /usr/local/data/<cluster-name>/SYSTEMS file for the names of the hosts in a cluster.  The file includes one FQDN host per line.  Lines starting with a '#' are ignored.

System inforamtion about each host is stored in /usr/local/data/<cluster-name>/<host>.  The system information includes cpu
temperature in Celsius and Fahrenheit, the system load, memory usage, and disk usage.  The system information will be used by blinkt to display system information about each system in near real time.

To avoid many login prompts for each host in a cluster, enter the following:  ssh-copy-id uadmin@<host-name>

I need to complete some cleanup before it is shareable and documented . . .

create-message.sh -> is found in /usr/local/data/cluster-1/SYSTEMS file.  Docker totals from these files are in /usr/local/data/cluster-1/MESSAGE for Scroll-pHAT on each system.  

display-message.py -> uses this information and displays it on Scroll-pHAT

still a lot of work to include blinkt

### Clone
To install, change to the location you want to download the scripts. Use git to pull or clone these scripts into the directory. If you do not have git then enter; "sudo apt-get install git". On the github page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/pi-display
    cd pi-display/scroll-phat

### System OS script tested
 * Ubuntu 16.04.3 LTS (armv7l)

### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root
 * Be easy to install and configure

### License::
Permission is hereby granted, free of charge, to any person obtaining a copy of this software, associated documentation, and files (the "Software") without restriction, including without limitation of rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
