# HotHead
iOS iPad app to monitor cylinder heads within airplane

Prerequisites
----
1. `autoconf automake libtool apple-gcc42 libyaml libxml2 libxslt libksba openssl`.
  Because `Ruby`. The best way to install, of course is
  [brew](http://mxcl.github.io/homebrew/).

    brew install autoconf automake libtool apple-gcc42 libyaml \
          libxml2 libxslt libksba openssl

    Note:
    ruby -e "$(curl - fsSL https://raw.github.com/mxcl/homebrew/go/install)"

2. Ruby. Because `Cocoapods`. The best way to install ruby is [rvm](https://rvm.io/).

    rvm install ruby 2.2.2
    rvm use ruby-2.2.2

3. Install Cocoapods. May be more too.

    sudo gem install cocoapods -v 1.0.0 --source http://rubygems.org
    pod setup
    pod install


Building
----

1. Fork & clone the code. SKIP
2. Install pods for the project

    go to the project directory
    pod install

3. Open the workspace

    open HotHead.xcworkspace

4. Be nice, do good work and stay in touch.
