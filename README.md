# invoiceninja-sandstorm

cd ~/projects
git clone git://github.com/n-a-m-e/invoiceninja-sandstorm
git clone git://github.com/invoiceninja/invoiceninja
cd ~/projects/invoiceninja
vagrant-spk setupvm lemp
cp -pfR ~/projects/invoiceninja-sandstorm/.sandstorm ~/projects/invoiceninja/.sandstorm
vagrant-spk vm up
