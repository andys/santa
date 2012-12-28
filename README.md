
### Santa: brings you your packages

Ever wished you could specify which Debian/Ubuntu packages your app needs in a format similar to bundler's Gemfile?

You can with santa.


    $ gem install santa

    $ cat <<EOF > Debfile
    deb "ruby1.9.1-dev"
    deb "nginx", repo: "ppa:nginx/stable"
    EOF

    $ santa
    --> sudo add-apt-repository -y ppa:nginx/stable
    --> sudo apt-get update
    --> sudo apt-get install -y ruby1.9.1-dev
    --> sudo apt-get install -y nginx
