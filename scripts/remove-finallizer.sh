export NAMESPACE=observability
export API_SERVER=$API_SERVER
export ACCESS_TOKEN=$ACCESS_TOKEN
curl -k -H "Content-Type: application/json" -H "Authorization: Bearer $ACCESS_TOKEN" -X PUT --data-binary @tmp.json $API_SERVER/api/v1/namespaces/$NAMESPACE/finalize