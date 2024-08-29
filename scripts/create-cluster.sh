
#check exist 
IS_EXIST=$(kind get clusters | grep $CLUSTER_CONTEXT)

# create kind cluster
if [ "$IS_EXIST" == "" ]
then
  kind create cluster --config $CLUSTER_CONFIG
fi

# use cluster context
kubectl config use-context "$CLUSTER_CONTEXT"