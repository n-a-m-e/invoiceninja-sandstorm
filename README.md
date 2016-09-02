# invoiceninja-sandstorm

install git, VirtualBox, vagrant and vagrant-spk as per the following link

https://docs.sandstorm.io/en/latest/vagrant-spk/installation/

To setup vagrant the following should do:

    mkdir -p ~/projects
    cd ~/projects
    git clone git://github.com/n-a-m-e/invoiceninja-sandstorm
    #goto https://www.invoiceninja.com/self-host/ to find latest package
    wget https://dl.dropboxusercontent.com/u/2909575/ninja-v2.6.10.zip
    unzip ninja-v2.6.10
    cd ~/projects/ninja
    vagrant-spk setupvm lemp
    vagrant-spk vm up
    vagrant-spk init
    cp -fR ~/projects/invoiceninja-sandstorm/.sandstorm ~/projects/ninja
    chmod +x ~/projects/ninja/.sandstorm/*.sh
    bash ~/projects/ninja/.sandstorm/update-pkgdef.sh
    bash ~/projects/ninja/.sandstorm/update-files-list.sh
    bash ~/projects/ninja/.sandstorm/fix-php-file.sh
    vagrant-spk dev
