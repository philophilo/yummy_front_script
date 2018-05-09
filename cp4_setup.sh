update_ubuntu(){
	echo ============================================= update ubuntu  ================================================================
    sudo apt-get update # update source list for packages and versions that can be installed
}

install_npm(){
	echo ============================================= install python3.6 ==============================================================
    sudo apt-get install npm # install npm
}

install_nodejs(){
	echo ============================================= install nodejs =================================================================
    curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
    sudo apt-get install -y nodejs # install nodejs
}

install_essentials(){
	echo ======================================== install build essentials ============================================================
    sudo apt-get install -y build-essential # references all the packages needed to compile a debian package
}


install_server(){
	echo ============================================== install nginx =================================================================
	sudo apt-get install -y nginx
}

nginx_setup(){
    echo ================================================= nginx setup ================================================================
    sudo systemctl start nginx # start nginx
    sudo cp yummy /etc/nginx/sites-available/ # copy nginx config to available sites
    sudo rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default # remove default nginx configurations
    sudo ln -s /etc/nginx/sites-available/yummy /etc/nginx/sites-enabled/ # create symbolic link to nginx new configuration
    sudo systemctl restart nginx # restart nginx
    sudo systemctl status nginx
}

app_setup(){
	echo ============================================= start application ==============================================================
	cd ..
    git clone https://github.com/philophilo/yummy-react.git # clone the repo
    cd yummy-react
    npm install # install dependencies in packages.json
    npm start # start application
}

run(){
    update_python
    install_npm
    install_nodejs
    install_essentials
    install_server
    nginx_setup
    app_setup
}

run
