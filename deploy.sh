# What are we doing here: <continuation from .travis.yaml>
#   ...
#   Build all out images, tag each one, push each to docker hub
#   Apply all configs in the k8s folder
#   Imperatively set latest images on each deployment


#   Build all our images, tag each one with 2 values (latest, git sha)
docker build -t rahul9712/dev-docker-multi-client:latest -t rahul9712/dev-docker-multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t rahul9712/dev-docker-multi-server:latest -t rahul9712/dev-docker-multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t rahul9712/dev-docker-multi-worker:latest -t rahul9712/dev-docker-multi-worker:$SHA -f ./worker/Dockerfile ./worker

# No need to re-login, as we already did that in before_install stage
# echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_ID" --password-stdin

# push each to docker hub
docker push rahul9712/dev-docker-multi-client:latest
docker push rahul9712/dev-docker-multi-server:latest
docker push rahul9712/dev-docker-multi-worker:latest
docker push rahul9712/dev-docker-multi-client:$SHA
docker push rahul9712/dev-docker-multi-server:$SHA
docker push rahul9712/dev-docker-multi-worker:$SHA

#   Apply all configs in the k8s folder
kubectl apple -f k8s


#   Imperatively set latest images on each deployment for this git version
kubectl set image deployments/client-deployment client=rahul9712/dev-docker-multi-client:$SHA
kubectl set image deployments/server-deployment server=rahul9712/dev-docker-multi-server:$SHA
kubectl set image deployments/worker-deployment worker=rahul9712/dev-docker-multi-worker:$SHA
