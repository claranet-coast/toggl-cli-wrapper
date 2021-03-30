# toggl-cli-wrapper

This script use the togglCli (python) to populate TOGGL

Requirements:
  - brew coreutils (brew install coreutils) for gdate
  - Python 3.7.3
  - togglCli for python (pip install togglCli)
  
For the usage and installation of togglCli see the documentation page: https://coast.xpeppers.com/#tutorial/togglcli.html

## How to run
`PROJECT_ID=12345 COMMAND=toggl bash ~/toggl-cli-wrapper/toggl.sh this_week`
COMMAND could be set to _echo toggl_ to enable debug and print only commands