# PopHealth development environment with Vagrant

This vagrant file with chef cookbooks will setup pophealth for development in a virtualbox/ubuntu environment.

## Instructions for setting it up

1. Install [VirtualBox](https://www.virtualbox.org/). 

2. Install [VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads).

3. Install [vagrant](http://vagrantup.com/).

4. [Download](https://github.com/port80labs/pophealth-vagrant/archive/master.zip) this Github repository or clone it. 

5. Obtain NLM username and password as described [here](https://github.com/pophealth/popHealth/wiki/Installation-v2.1#7-import-the-measure-bundle) and add them in the [Vagrantfile](https://github.com/port80labs/pophealth-vagrant/blob/master/Vagrantfile)

5. Type <code>vagrant up</code> in the directory of this code.

## Caveats

This has been only tested on the Mac OS platform. If you try it on a different platform please let me know of any issues and successes so i can update this readme. 

## Props

Hat tip to [ringful](https://github.com/ringful/pophealth-chef) for https://github.com/ringful/pophealth-chef and detailed instructions on [pophealth wiki](https://github.com/pophealth/popHealth/wiki/Installation-v2.1)