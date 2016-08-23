# invoiceninja-sandstorm

install git, VirtualBox, vagrant and vagrant-spk as per the following link

https://docs.sandstorm.io/en/latest/vagrant-spk/installation/

To setup vagrant the following should do:

    mkdir -p ~/projects
    cd ~/projects
    git clone git://github.com/n-a-m-e/invoiceninja-sandstorm
    git clone git://github.com/invoiceninja/invoiceninja
    cd ~/projects/invoiceninja
    vagrant-spk setupvm lemp
    cp -pfR ~/projects/invoiceninja-sandstorm/.sandstorm ~/projects/invoiceninja/.sandstorm
    vagrant-spk vm up
    vagrant-spk dev
