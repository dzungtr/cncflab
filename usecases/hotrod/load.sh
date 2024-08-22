kubectl --namespace sample-application run strzal --image=djbingham/curl \
  --restart='OnFailure' -i --tty --rm --command -- curl -X POST -F \
  'user_count=6' -F 'spawn_rate=2' http://locust-master:8089/swarm