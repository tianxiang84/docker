The purpose here is to see if I can use a entrypoint script to catch the SIGTERM signal by docker stop and perform some clean up/saving tasks automatically when stopping the docker container.

Notes:
- PID=1
- SIGTERM is by docker stop; SIGKILL is by docker kill

Tests:
1. Create a bash entrypoint script to run infinite loop
