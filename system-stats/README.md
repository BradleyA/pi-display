## pi-system-stats

#### WARNING: These instructions are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!

pi-system-stats is a bash script that runs several commands and has notes about other commands I am looking at a future use with logging and monitoring with blinkt and scroll-phat in my unicorn project.

<img id="image_raspberry_cluster" src="../images/IMG_2664.JPG" width="200" >


#### WARNING: These instructions are incomplete. Consider them as notes quickly drafted on a napkin rather than proper documentation!
Need to continue to organize the research from the many systems running different test cases.   Organize it into; what works, what I want, and what I still need to make this design work:
This is work in progress:
  1) use create-message.sh to create data and store data on each system in a cluster
  2) need to move create-meaage.sh in a docker container on cluster-1, three-rpi3b, cluster-2, six-rpi3b, cluster-3
  3) 
  
  
### Working on:
    display-led.py
    --> need one container running on each system in cluster with blinkt
    #       display-led.py  3.08.85  2018-03-14_21:59:15_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.07-2-g5f6290c  
    #          added more prices, first draft of display-led.py 
    ###
    #       The final design should control an Blinkt LED bar and
    #               display information for a second
    #               So this means it will take 8 seconds to display all LEDS?
    #       Each color level function will exit with the primary color on
    #       Color brightness controlled in each color level function
    #
    #       Other containers will update a volume that this container mounts
    #               and reads (LED_number, Level)
    ###
    
    main
    --> example Dockerfile and yaml to use with other scripts
    Dockerfile
    rainbow.py
    build
    docker-compose.yaml
    
    main/system-stats-1.sh
    --> not sure if still needed
    
    scrollphat/create-message.sh
    --> need one container always running on one system in cluster
    This script stores Docker information about containers and images in a file"
    on each system in a cluster.  These files are copied to a host and totaled"
    in a file, /usr/local/data/<cluster-name>/MESSAGE.  The MESSAGE file includes"
    the total number of containers, running containers, paused containers,"
    stopped containers, and number of images.  The MESSAGE file is used by a"
    Raspberry Pi Scroll-pHAT to display the information."
    This script reads /usr/local/data/<cluster-name>/SYSTEMS file for the names"
    of the hosts in a cluster.  The file includes one FQDN host per line.   Lines"
    starting with a '#' are ignored.
    
    scrollphat/display-message.py
    --> need one container running system with scroll board in cluster

### Install

To install, change to the directory, cd /usr/local/bin, to download the script.

    curl -L https://api.github.com/repos/BradleyA/Linux-admin-scripts/tarball | tar -xzf - --wildcards */system-stat-* ; mv BradleyA-Linux-admin-scripts-*/system-stat/system-stat-* . ; rm -rf BradleyA-Linux-admin-scripts-*
    curl -L https://api.github.com/repos/BradleyA/pi-display/tarball | tar -xzf - --wildcards *cpu-temperature/cpu-temperature.sh ; mv BradleyA-pi-display-*/cpu-temperature/cpu-temperature.sh . ; rm -rf BradleyA-pi-display-*

### Clone

To clone, change to the directory you want to download the script, README, and host file. Use git to clone these files into your directory. If you do not have git then enter; "sudo apt-get install git". On the github page of this script use the "HTTPS clone URL" with the 'git clone' command.

    git clone https://github.com/BradleyA/Linux-admin-scripts
    cd Linux-admin-scripts/system-stat

### Usage
    system-stats-1.sh

### Output
    $ system-stats-1.sh 
    Need to determine what I want to use in these notes to move forward with this project.  On hold until a later time.
    
     -->  Hostname =  one-rpi3b
     Celsius =	 35.4
    Fahrenheit =	95.72
    processor	: 0
    model name	: ARMv7 Processor rev 4 (v7l)
    BogoMIPS	: 38.40
    Features	: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32 
    CPU implementer	: 0x41
    CPU architecture: 7
    CPU variant	: 0x0
    CPU part	: 0xd03
    CPU revision	: 4
    
    processor	: 1
    model name	: ARMv7 Processor rev 4 (v7l)
    BogoMIPS	: 38.40
    Features	: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32 
    CPU implementer	: 0x41
    CPU architecture: 7
    CPU variant	: 0x0
    CPU part	: 0xd03
    CPU revision	: 4
    
    processor	: 2
    model name	: ARMv7 Processor rev 4 (v7l)
    BogoMIPS	: 38.40
    Features	: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32 
    CPU implementer	: 0x41
    CPU architecture: 7
    CPU variant	: 0x0
    CPU part	: 0xd03
    CPU revision	: 4
    
    processor	: 3
    model name	: ARMv7 Processor rev 4 (v7l)
    BogoMIPS	: 38.40
    Features	: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32 
    CPU implementer	: 0x41
    CPU architecture: 7
    CPU variant	: 0x0
    CPU part	: 0xd03
    CPU revision	: 4
    
    Hardware	: BCM2709
    Revision	: a02082
    Serial		: 0000000052f2b2ab
    
    arm:	frequency(45)=600062000
    core:	frequency(1)=250000000
    h264:	frequency(28)=250000000
    isp:	frequency(42)=249999000
    v3d:	frequency(43)=250000000
    uart:	frequency(22)=47999000
    pwm:	frequency(25)=0
    emmc:	frequency(47)=250000000
    pixel:	frequency(29)=0
    vec:	frequency(10)=108000000
    hdmi:	frequency(9)=0
    dpi:	frequency(4)=0
    
    /opt/vc/bin/vcgencmd measure_temp
    temp=35.4'C
    
    /opt/vc/bin/vcgencmd measure_volts
    volt=1.2375V
    
    core:	volt=1.2375V
    sdram_c:	volt=1.2000V
    sdram_i:	volt=1.2000V
    sdram_p:	volt=1.2250V
    
    /usr/bin/vcgencmd measure_temp
    temp=35.4'C
    
    arm_freq=1200
    audio_pwm_mode=1
    config_hdmi_boost=5
    core_freq=400
    desired_osc_freq=0x36ee80
    disable_commandline_tags=2
    disable_l2cache=1
    force_eeprom_read=1
    force_pwm_open=1
    framebuffer_ignore_alpha=1
    framebuffer_swap=1
    gpu_freq=300
    hdmi_force_cec_address=65535
    init_uart_clock=0x2dc6c00
    lcd_framerate=60
    over_voltage_avs=37500
    overscan_bottom=32
    overscan_left=32
    overscan_right=32
    overscan_top=32
    pause_burst_frames=1
    program_serial_random=1
    sdram_freq=450
    temp_limit=85
    
    arm=944M
    gpu=64M
    
    Dec  9 2016 15:11:26 
    Copyright (c) 2012 Broadcom
    version 2e557d8dac70add28597c3b449cb52c34588d818 (clean) (release)
    
    CPU model:  ARMv7 Processor rev 4 (v7l)
    1 CPU,  physical cores per CPU, total 4 logical CPU units

#### System OS script tested
 * Ubuntu 14.04.3 LTS
 * Ubuntu 16.04.3 LTS (armv7l)

#### Design Principles
 * Have a simple setup process and a minimal learning curve
 * Be usable as non-root
 * Be easy to install and configure

## License
MIT License

Copyright (c) 2019  Bradley Allen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

