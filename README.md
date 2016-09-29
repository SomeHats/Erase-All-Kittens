# Erase All Kittens
[![Build Status](https://travis-ci.org/drumrollhq/E.A.K..svg?branch=dev)](https://travis-ci.org/drumrollhq/E.A.K.)

[E.A.K.](http://eraseallkittens.com/) is a new open source game that teaches kids to code and create on the web. Levels are written in `HTML` and `CSS`, but most are impossible until you hack in to them and modify their source code.

The story of E.A.K. is that cute animals on the Internet hate kittens, because they get all the views. They form the evil operation E.A.K. - Erase All Kittens. You must use your coding super powers to save the kittens, and consequently the entire Internet.

## Try it online
We have an *early* demo you can play at [http://eraseallkittens.com/](http://eraseallkittens.com/).

![Screenshot Erase All Kittens!](screenshots-Erase-All-Kittens.png)

## Team & project
E.A.K. is designed and built in London by [Drum Roll](http://drumrollhq.com). We're something between a games company and an ed-tech startup, and we're huge fans of the Open Web.

The aim of the project is to teach kids real, practical coding skills. After playing the game, we want people to be able to build and publish their own creations on the web.

If you’re interested in what we've done so far or would like to help out, we'd love to hear from you. Fill out the form on [our website](http://eraseallkittens.com/), and we'll get in touch. If you just want to dive straight in and checkout the code, read on :)

## Installing
In order to build E.A.K, you'll need to be comfortable using your computer's terminal. First off, follow the instructions linked to below to install everything you need to get E.A.K. up and running.
* [Git](http://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [Node.JS](http://nodejs.org/download/)
* [Bower](http://bower.io/#install-bower)
* [Gulp](https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md)
* [FFMPEG](https://www.ffmpeg.org/download.html)
    - Mac users, your best bet for FFMPEG is to use [Homebrew](http://brew.sh/) and run `brew install ffmpeg --with-theora --with-libogg --with-libvorbis --with-libfaac --with-faac --with-libvpx`
* [ImageMagick](http://www.imagemagick.org/script/binary-releases.php)
    - Again, brew is the best bet for mac users

Next, you'll need to download E.A.K. and its dependencies. Run the following on your terminal:
```sh
  git clone --recursive https://github.com/drumrollhq/E.A.K..git
  cd E.A.K.
  git submodule init
  git submodule update
  npm install
  bower install
```

Note: E.A.K. is a pretty big project, and can take a long time to clone. If you want to speed things up, you can clone with `git clone --recursive --depth 25 https://github.com/drumrollhq/E.A.K..git` to only download recent history.

## Building
OK. That was a lot of stuff to install. Hopefully now, we're ready to build E.A.K.

In your terminal, run:
```sh
gulp build
```

This will take a little while initially as it has to convert all the game assets, but should be quicker with subsequent runs.

To get E.A.K. running in the browser, run `gulp`. This will:

- Run `gulp build`
- Watch for changes to E.A.K. source and rebuild when needed
- Start a webserver on port 4000. Go to http://localhost:4000/ in your web browser!

Congratulations! You're now (probably) running E.A.K! If you're not, sorry! Please email joe [at] drumrollhq.com and I'll try and help you, and update this guide if I can :)

