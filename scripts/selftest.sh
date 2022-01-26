#!/bin/bash

echo "-----------------------------------------"
echo "/ _\ ___| |/ _| |_ ___  ___| |_ ___ _ __"
echo "\ \ / _ \ | |_| __/ _ \/ __| __/ _ \ '__|"
echo "_\ \  __/ |  _| ||  __/\__ \ ||  __/ |"
echo "\__/\___|_|_|  \__\___||___/\__\___|_|"
echo "-----------------------------------------"

echo -e "# \e[1;35mMaking directory\e[0m"
mkdir -p /code/selftest
cd /code/selftest


#### Scenario 1 ####

echo -e "# \e[1;33mScenario 1: Assume we have version 1.1.3, and composer.json has constraint ^1.1\e[0m"

echo -e "# \e[1;35mRequire psr/log 1.1.3\e[0m"
composer require psr/log:1.1.3
if [[ $(composer outdated) ]]; then echo -e "# \e[1;35mThere are updates. Perfect, it's what we want.\e[0m"; else echo -e "# \e[1;31mComposer reporting nothing to update. That's bad news.\e[0m"; exit 1; fi
echo -e "# \e[1;35mRequire psr/log ^1.1\e[0m"
composer require psr/log:^1.1
echo -e "# \e[1;35mActual update via composer\e[0m"
composer update

if [[ $(composer outdated) ]]; then echo -e "# \e[1;31mThere are still updates. Something went horribly wrong.\e[0m"; exit 1; else echo -e "# \e[1;35mComposer reporting nothing to update; Perfect!\e[0m"; fi

echo -e "# \e[1;33mEnd of scenario 1\e[0m"

####################

#### Scenario 2 ####
echo -e "# \e[1;33mScenario 2: Assume we have version 1.1.3, and composer.json has constraint 1.1.3\e[0m"

echo -e "# \e[1;35mRequire psr/log 1.1.3\e[0m"
composer require psr/log:1.1.3
if [[ $(composer outdated) ]]; then echo -e "# \e[1;35mThere are updates. Perfect, it's what we want.\e[0m"; else echo -e "# \e[1;31mComposer reporting nothing to update. That's bad news.\e[0m"; exit 1; fi

echo -e "# \e[1;35mCheck if newer version is available\e[0m"
composer outdated --direct > outdated.txt
echo -e "# \e[1;35mUpdate contraints\e[0m"
php /usr/local/bin/uv.php
echo -e "# \e[1;35mActual update via composer\e[0m"
composer update

if [[ $(composer outdated) ]]; then echo -e "# \e[1;31mThere are still updates. Something went horribly wrong.\e[0m"; exit 1; else echo -e "# \e[1;35mComposer reporting nothing to update; Perfect!\e[0m"; fi

echo -e "# \e[1;33mEnd of scenario 2\e[0m"
####################

echo -e "# \e[1;35mEnd of selftest\e[0m"
