By the Grace of God, He helped me use AI to make an automated install of guacamole. Through troubleshooting, this is the results. I fully working docker install in alpine.
## NOTE:
### the "setup-guac.sh" file MUST be run after installing the containers to setup the SQL database. It can be adjusted to your distro. vi or nano setup-guac.sh and adjust as needed.
then run
### chmod +x setup-guac.sh && ./setup-guac.sh to run

Now you can access your guacamole at http:localhost:8080/guacamole/#/
