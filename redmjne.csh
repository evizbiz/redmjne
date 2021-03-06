#!/bin/csh
# refs:
# joe kutner -- "deploying with jruby" pragmatic programmers facets of ruby series
# http://saltnlight5.blogspot.com/2012/08/how-to-generate-redmine-war-application.html
# http://thenice.tumblr.com/post/133345213/deploying-a-rails-application-in-tomcat-with-jruby-a
# http://jabox.tumblr.com/post/18973862661/how-to-get-redmine-1-3-1-running-in-2-minutes
#
# work with the latest releases (redmine, jruby, tomcat):
# feb 2014 releases:
set cwd = `pwd`
set envset = './env.csh' 
if ( ! -e ${envset} ) then
  echo "please make sure the current working directory includes ${envset} ..."
  exit
endif
source ${envset} $argv
#
set opt = "env"
set cwd = `pwd`
#find $ASSETS -type d | egrep -v '\.svn|\.git|\.\.'
if ( $1 != "" ) set opt = "$1"
if ( "$opt" == "env" ) exit
#
# do all work in ./build sub-dir:
if ( "$opt" == "all" || "$2" == "all" ) then
# fetch apache-tomcat, jruby, and redmine dependencies
  source ./fetch.csh $argv # can run stand-alone, so it also pushd and popd to/from ./build
endif
# regardless if new jruby was fetched, need to check that jruby is in path
# rake tasks may need jruby in path
which jruby
if ( $? != 0 ) then
  setenv PATH $cwd/build/jruby/bin':'$PATH
  rehash
  which jruby
endif
if ( "$opt" == "all" || "$2" == "all" ) then
# note minor hand-edits of Gemfiles for version deps. may be needed too:
  source ./gems.csh $argv # can also run stand-alone, so it also pushd and popd to/from ./build
  if ( "$2" != "" && "$2" != "all" ) set $opt = "$2"
endif
#
if ( "$opt" != "new" ) source ./assets.csh $argv
source ./war.csh $argv
ls -al ./build/*.war

