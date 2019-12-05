![architecture][1]

The whole app is divided into three Containers:

1. nginx is running in `nginx` Container, which handles requests and makes responses.
2. node  is put in `nodejs` Container, it retrieves nodejs scripts from host, interprets, executes then responses to Nginx. If necessary, it will connect to `mysql` as well.
3. mysql lies in `mysql` Container,

Our app scripts are located on host, you can edit files directly without rebuilding/restarting whole images/containers.

