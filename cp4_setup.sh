update_ubuntu(){
	echo ============================================= update ubuntu  ================================================================
    sudo apt-get -y update # update source list for packages and versions that can be installed
}

install_npm(){
	echo ============================================= installing npm ==============================================================
    sudo apt-get install -y npm # install npm
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
    # sudo systemctl restart nginx # restart nginx
    # sudo systemctl status nginx
}

setup_ssh_certbot(){
    echo ================================================= certbot setup ============================================================
    sudo add-apt-repository -y ppa:certbot/certbot
    sudo apt-get update
    sudo pip install cffi
    sudo apt-get install -y python-certbot-nginx
    sudo certbot --nginx
}

start_nginx(){
    sudo systemctl restart nginx # restart nginx
    sudo systemctl status nginx
}

setup_supervisor(){
    echo ================================================= supervisor setup ============================================================
    sudo apt-get install -y supervisor
    sudo cp front.conf /etc/supervisor/conf.d/yummy.conf
}

app_setup(){
	echo ============================================= start application ==============================================================
	cd ..
    git clone -b production https://github.com/philophilo/yummy-react.git # clone the repo
    cd yummy-react
    npm install # install dependencies in packages.json
}

start_app(){
    echo ================================================= start with gunicorn ======================================================
    sudo supervisorctl reread
    sudo supervisorctl update
    sudo supervisorctl start yummy
    # fix ubuntu 16.04 bug, race between systemd and nginx. 
    # As if systemd expects the PID file to be populated before nginx has the time to create it.
    sudo mkdir /etc/systemd/system/nginx.service.d
    printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > override.conf
    sudo mv override.conf /etc/systemd/system/nginx.service.d/override.conf
    sudo systemctl daemon-reload
    sudo systemctl restart nginx 
}

run(){
    update_ubuntu
    update_python
    install_npm
    install_nodejs
    install_essentials
    install_server
    nginx_setup
    setup_ssh_certbot
    start_nginx
    setup_supervisor
    app_setup
    start_app
}

run
